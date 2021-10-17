module AuthorizationsHelper
  def auth_form_for(form_type)
    if form_type == :register
      render 'shared/sign_up'
    elsif form_type == :login
      render 'shared/sign_in'
    end
  end

  def error_messages(model:, flash:)
    arr = nil
    arr = model.errors.full_messages if model && model.errors.size > 0
    arr = [flash] if flash
    render partial: 'shared/error_box', locals: { messages: arr } if arr
  end
end