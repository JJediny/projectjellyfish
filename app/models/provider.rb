# == Schema Information
#
# Table name: providers
#
#  id                     :integer          not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  deleted_at             :datetime
#  type                   :string           not null
#  registered_provider_id :integer          not null
#  name                   :string           not null
#  description            :text
#  active                 :boolean
#  cached_tag_list        :string
#
# Indexes
#
#  index_providers_on_registered_provider_id  (registered_provider_id)
#  index_providers_on_type                    (type)
#

class Provider < ActiveRecord::Base
  acts_as_paranoid
  acts_as_taggable

  has_many :answers, as: :answerable
  belongs_to :registered_provider

  accepts_nested_attributes_for :answers, reject_if: -> (answer) { answer['value'].nil? }

  def self.policy_class
    ProviderPolicy
  end

  private

  def settings
    @_settings ||= Hash[answers.map { |answer| [answer.name.to_sym, answer.value] }]
  end
end
