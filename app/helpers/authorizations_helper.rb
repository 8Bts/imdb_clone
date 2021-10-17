module AuthorizationsHelper
  def auth_form_for(form_type)
    case form_type
    when :register
      render 'shared/sign_up'
    when :login
      render 'shared/sign_in'
    end
  end

  def error_messages(model:, flash:)
    arr = nil
    arr = model.errors.full_messages if model && model.errors.size.positive?
    arr = [flash] if flash
    render partial: 'shared/error_box', locals: { messages: arr } if arr
  end
end
