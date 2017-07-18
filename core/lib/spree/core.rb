require 'rails/all'
require 'active_merchant'
require 'acts_as_list'
require 'awesome_nested_set'
require 'cancan'
require 'friendly_id'
require 'kaminari'
require 'mail'
require 'monetize'
require 'paperclip'
require 'paranoia'
require 'ransack'
require 'state_machines-activerecord'
require 'responders'

# This is required because ActiveModel::Validations#invalid? conflicts with the
# invalid state of a Payment. In the future this should be removed.
StateMachines::Machine.ignore_method_conflicts = true

module Spree
  mattr_accessor :user_class

  def self.user_class
    if @@user_class.is_a?(Class)
      raise "Spree.user_class MUST be a String or Symbol object, not a Class object."
    elsif @@user_class.is_a?(String) || @@user_class.is_a?(Symbol)
      @@user_class.to_s.constantize
    end
  end

  # Used to configure Spree.
  #
  # Example:
  #
  #   Spree.config do |config|
  #     config.track_inventory_levels = false
  #   end
  #
  # This method is defined within the core gem on purpose.
  # Some people may only wish to use the Core part of Spree.
  def self.config(&_block)
    yield(Spree::Config)
  end

  module Core
    autoload :ProductFilters, "spree/core/product_filters"

    class GatewayError < RuntimeError; end
    class DestroyWithOrdersError < StandardError; end
  end
end

require 'spree/core/version'

require 'spree/core/class_constantizer'
require 'spree/core/environment_extension'
require 'spree/core/environment/calculators'
require 'spree/core/environment'
require 'spree/promo/environment'
require 'spree/migrations'
require 'spree/migration_helpers'
require 'spree/core/engine'

require 'spree/i18n'
require 'spree/localized_number'
require 'spree/money'
require 'spree/permitted_attributes'

require 'spree/core/importer'
require 'spree/core/permalinks'
require 'spree/core/product_duplicator'
require 'spree/core/current_store'
require 'spree/core/controller_helpers/auth'
require 'spree/core/controller_helpers/common'
require 'spree/core/controller_helpers/order'
require 'spree/core/controller_helpers/payment_parameters'
require 'spree/core/controller_helpers/pricing'
require 'spree/core/controller_helpers/search'
require 'spree/core/controller_helpers/store'
require 'spree/core/controller_helpers/strong_parameters'
require 'spree/core/role_configuration'
require 'spree/core/stock_configuration'
require 'spree/permission_sets'
require 'spree/deprecation'

require 'spree/core/price_migrator'

require 'spree/preferences/preferable_class_methods'
require 'spree/preferences/preferable'
require 'concerns/spree/ransackable_attributes'
require 'concerns/spree/display_money'
require 'concerns/spree/default_price'
require 'concerns/spree/calculated_adjustments'
require 'concerns/spree/adjustment_source'

require 'spree/base'

require 'spree/user_class_handle'
require 'spree/product'

require 'spree/variant'

require 'spree/order/payments'
require 'spree/order'
require 'spree/line_item'

require 'spree/promotion'
require 'spree/order_promotion'
require 'spree/promotion_rule'
require 'spree/promotion_rule_role'
require 'spree/promotion_action'
require 'spree/promotion/actions/create_adjustment'
require 'spree/promotion/actions/create_item_adjustments'
require 'spree/promotion/actions/create_quantity_adjustments'
require 'spree/promotion/actions/free_shipping'
require 'spree/promotion/rules/user'
require 'spree/promotion/rules/product'
require 'spree/promotion/rules/option_value'
require 'spree/promotion/rules/first_order'
require 'spree/promotion/rules/nth_order'
require 'spree/promotion/rules/user_logged_in'
require 'spree/promotion/rules/first_repeat_purchase_since'
require 'spree/promotion/rules/user_role'
require 'spree/promotion/rules/item_total'
require 'spree/promotion/rules/one_use_per_user'
require 'spree/promotion/rules/taxon'
require 'spree/promotion_handler/coupon'
require 'spree/promotion_handler/page'
require 'spree/promotion_handler/cart'
require 'spree/promotion_handler/free_shipping'
require 'spree/promotion_code'
require 'spree/promotion_code/batch_builder'
require 'spree/promotion_category'
require 'spree/promotion_chooser'
require 'spree/promotion_rule_taxon'
require 'spree/promotion_code_batch'
require 'spree/promotion_rule_user'
require 'spree/product_promotion_rule'

require 'spree/tax/tax_helpers'
require 'spree/tax/tax_location'

require 'spree/tax_calculator/default'
require 'spree/tax_calculator/shipping_rate'
require 'spree/tax_category'
require 'spree/tax/item_tax'
require 'spree/tax/order_adjuster'
require 'spree/tax/order_tax'
require 'spree/tax_rate'
require 'spree/tax_rate_tax_category'
require 'spree/tax/shipping_rate_taxer'

require 'spree/calculator'
require 'spree/calculator/default_tax'
require 'spree/calculator/distributed_amount'
require 'spree/calculator/flat_percent_item_total'
require 'spree/calculator/flat_rate'
require 'spree/calculator/flexi_rate'
require 'spree/calculator/free_shipping'
require 'spree/calculator/percent_on_line_item'
require 'spree/calculator/percent_per_item'
require 'spree/calculator/price_sack'
require 'spree/calculator/returns/default_refund_amount'
require 'spree/calculator/shipping/flat_percent_item_total'
require 'spree/calculator/shipping/flat_rate'
require 'spree/calculator/shipping/flexi_rate'
require 'spree/calculator/shipping/per_item'
require 'spree/calculator/shipping/price_sack'
require 'spree/calculator/tiered_flat_rate'
require 'spree/calculator/tiered_percent'


# our models rely on paperclip to be initialized by rails init, which isn't guaranteed to have ran when solidus_core is loaded.
# TODO: Find a better place for this
Paperclip::Railtie.insert unless ActiveRecord::Base.ancestors.include? Paperclip::Glue

require 'spree/taxon'
require 'spree/taxonomy'

require 'spree/return_item/eligibility_validator/base_validator'
require 'spree/return_item/eligibility_validator/inventory_shipped'
require 'spree/return_item/eligibility_validator/no_reimbursements'
require 'spree/return_item/eligibility_validator/order_completed'
require 'spree/return_item/eligibility_validator/rma_required'
require 'spree/return_item/eligibility_validator/time_since_purchase'
require 'spree/return_item/eligibility_validator/default'
require 'spree/return_item/exchange_variant_eligibility/same_option_value'
require 'spree/return_item/exchange_variant_eligibility/same_product'
require 'spree/return_item'
