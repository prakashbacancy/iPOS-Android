module LocationModule
  extend ActiveSupport::Concern

  # define common association
  included do
    after_create :create_location
    after_destroy :delete_location
  end

  def create_location
    binding.pry
    Apartment::Tenant.create(self.subdomain)
  end

  def delete_location
    Apartment::Tenant.drop(self.subdomain)
  end
end