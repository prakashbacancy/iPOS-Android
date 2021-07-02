class Location < ApplicationRecord
	include LocationModule

	before_create :update_subdomain
	def update_subdomain
    subdomain_value = self.business_name.parameterize(separator: "")
    self.subdomain = Location.create_sub_domain(subdomain_value)
  end

  def self.create_sub_domain(subdomain_value, index=0)
    subdomain_to_set = index.zero? ? subdomain_value : "#{subdomain_value}#{index}"
    if Location.where(subdomain: subdomain_to_set).present?
      Location.create_sub_domain(subdomain_value, index+1)
    else
      subdomain_to_set
    end
  end
end
