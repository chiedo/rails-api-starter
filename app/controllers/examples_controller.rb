class ExamplesController < BaseController
  skip_before_filter :authenticate_user_from_token!, :only => [:example_public]
  skip_before_filter :block_unauthenticated_user!, :only => [:example_public]

  def example_public
    render body: 'Public'
  end

  def example_private
    render body: 'Private'
  end
end
