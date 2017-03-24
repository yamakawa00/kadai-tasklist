class TasksController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]
  
  def index
    @tasks = Task.order(id: :asc).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @task = Task.new(content: 'task name')
  end

  def create
    # @task = Task.new(task_params)
    @task = current_user.tasks.build(task_params)
    
    if @task.save
      flash[:success] = 'Task が正常に投稿されました'
      redirect_to root_url
    else
      flash[:danger] = 'Task が投稿されませんでした'
      redirect_to root_url
      # flash.now[:danger] = 'Task が投稿されませんでした'
      # render 'tesks/new'
      # render :new
    end
  end

  def edit
    if correct_user === false
      flash[:danger] = '権限がありません。'
    end
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to root_path
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy
    
    flash[:success] = 'Task を削除しました。'
    redirect_back(fallback_location: root_path)
  end
  

  private
  
  def set_message
    @task = Task.find(params[:id])
  end

  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end
  
  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    unless @task
      redirect_to root_path
      return false
    end
  end
end