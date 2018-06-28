module Apartment
  module ActiveJob
    extend ActiveSupport::Concern

    class_methods do
      def execute(job_data)
        Apartment::Tenant.switch(job_data['tenant']) do
          super
        end
      end
    end
    
    def enqueue(*arguments)
      @tenant = Apartment::Tenant.current
      Apartment::Tenant.switch('public') do
        super(*arguments)
      end
    end
    
    def serialize
      super.merge('tenant' => @tenant)
    end
  end
end
