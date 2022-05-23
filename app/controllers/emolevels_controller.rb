class EmolevelsController < ApplicationController
	def create
    @user = User.find(params[:user_id])
    @emolevel = @user.emolevels.create(emolevel_params)
    redirect_to user_path(@user)
  end

  private
    def emolevel_params
      params.require(:emolevel).permit(:scale1, :scale2, :scale3, :scale4, :scale5, :emosum, :time)
    end
end