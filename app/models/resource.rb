class Resource < ActiveRecord::Base
  belongs_to :account
  has_many :debt_files, :dependent => :delete_all
  has_many :debts, through: :debt_files

  @@CHARS = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a

  has_attached_file :resource,
    :styles => { 
      :medium => { :geometry => "400x400>",
                   :format => :png
                 }, 
      :thumb => { :geometry => "100x100>",
                   :format => :png
                 }
    },
    
    :url => "/system/resources/:id/:style/:basename.:extension",
    :path => ":rails_root/public/system/resources/:id/:style/:basename.:extension",
    :default_url => "/images/:style/missing.png"

  include Rails.application.routes.url_helpers

  validates_attachment_content_type :resource, content_type: 
      ['image/jpeg', 'image/jpg', 'image/png', 'image/x-png', 'image/gif', 'image/tiff', 
        'application/pdf', 'application/msword', 'text/plain',
        'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document']


  def to_jq_resource
    {
      "id" => read_attribute(:id),
      "name" => read_attribute(:resource_file_name),
      "display_name" => read_attribute(:display_name),
      "size" => read_attribute(:resource_file_size),
      "url" => resource.url(:original),
      "thumbnail_url" => resource.url(:thumb),
      "content_type" => read_attribute(:resource_content_type),
      #"update_at" => read_attribute(:update_at),
      "delete_url" => resource_path(self),
      "delete_type" => "DELETE" 
    }
  end

  def self.search(search)
    if search
      Resource.where("display_name like '%#{search.downcase}%'")
    else
      all
    end
  end

  def self.random_file_name
    (0..8).map{@@CHARS.sample}.join
  end
end
