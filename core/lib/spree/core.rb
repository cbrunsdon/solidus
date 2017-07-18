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

require 'spree/validations/db_maximum_length_validator'

require 'spree/preferences/preferable_class_methods'
require 'spree/preferences/preferable'
require 'concerns/spree/ransackable_attributes'
require 'concerns/spree/display_money'
require 'concerns/spree/default_price'
require 'concerns/spree/calculated_adjustments'
require 'concerns/spree/adjustment_source'
require 'concerns/spree/named_type'
require 'concerns/spree/user_api_authentication'
require 'concerns/spree/user_reporting'
require 'concerns/spree/user_address_book'
require 'concerns/spree/user_payment_source'
require 'concerns/spree/user_methods'
require 'concerns/spree/ordered_property_value_list'

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

require 'spree/refund_reason'
require 'spree/refund'

require 'spree/reimbursement_type'
require 'spree/reimbursement_type/reimbursement_helpers'
require 'spree/reimbursement_type/credit'
require 'spree/reimbursement_type/exchange'
require 'spree/reimbursement_type/original_payment'
require 'spree/reimbursement_type/store_credit'

require 'spree/payment_source'
require 'spree/store_credit'

require 'spree/reimbursement_tax_calculator'
require 'spree/reimbursement/credit'
require 'spree/reimbursement/reimbursement_type_validator'
require 'spree/reimbursement/reimbursement_type_engine'
require 'spree/reimbursement_performer'
require 'spree/reimbursement'

require 'spree/preference'
require 'spree/preferences/configuration'
require 'spree/preferences/scoped_store'
require 'spree/preferences/statically_configurable'
require 'spree/preferences/static_model_preferences'
require 'spree/preferences/store'

require 'spree/payment_method'
require 'spree/payment_method/credit_card'
require 'spree/payment_method/bogus_credit_card'
require 'spree/payment_method/check'
require 'spree/payment_method/simple_bogus_credit_card'
require 'spree/payment_method/store_credit'

require 'spree/store'
require 'spree/store_credit_category'
require 'spree/store_credit_event'
require 'spree/store_credit_type'
require 'spree/store_credit_update_reason'
require 'spree/store_payment_method'
require 'spree/store_selector/by_server_name'
require 'spree/store_selector/legacy'


require 'spree/ability'
require 'spree/address'
require 'spree/adjustment'
require 'spree/adjustment_reason'
require 'spree/asset'
require 'spree/billing_integration'
require 'spree/carton'
require 'spree/classification'
require 'spree/country'
require 'spree/credit_card'
require 'spree/customer_return'
require 'spree/distributed_amounts_handler'
require 'spree/exchange'
require 'spree/gateway'
require 'spree/gateway/bogus'
require 'spree/gateway/bogus_simple'
require 'spree/image'
require 'spree/inventory_unit'
require 'spree/legacy_user'
require 'spree/line_item_action'
require 'spree/log_entry'
require 'spree/option_type'
require 'spree/option_value'
require 'spree/option_values_variant'
require 'spree/order_cancellations'
require 'spree/order_capturing'
require 'spree/order/checkout'
require 'spree/order_contents'
require 'spree/order_inventory'
require 'spree/order_merger'
require 'spree/order_mutex'
require 'spree/order/number_generator'
require 'spree/order_shipping'
require 'spree/order_stock_location'
require 'spree/order_taxation'
require 'spree/order_update_attributes'
require 'spree/order_updater'
require 'spree/payment/processing'
require 'spree/payment'
require 'spree/payment_capture_event'
require 'spree/payment_create'
require 'spree/price'
require 'spree/product_option_type'
require 'spree/product_property'
require 'spree/product/scopes'
require 'spree/property'
require 'spree/return_authorization'
require 'spree/return_reason'
require 'spree/returns_calculator'
require 'spree/role'
require 'spree/role_user'
require 'spree/shipment'
require 'spree/shipping_calculator'
require 'spree/shipping_category'
require 'spree/shipping_manifest'
require 'spree/shipping_method'
require 'spree/shipping_method_category'
require 'spree/shipping_method_stock_location'
require 'spree/shipping_method_zone'
require 'spree/shipping_rate'
require 'spree/shipping_rate_tax'
require 'spree/state'
require 'spree/state_change'
require 'spree/stock/adjuster'
require 'spree/stock/availability_validator'
require 'spree/stock/content_item'
require 'spree/stock/coordinator'
require 'spree/stock/differentiator'
require 'spree/stock/estimator'
require 'spree/stock/inventory_unit_builder'
require 'spree/stock/inventory_validator'
require 'spree/stock_item'
require 'spree/stock_location'
require 'spree/stock_movement'
require 'spree/stock/package'
require 'spree/stock/packer'
require 'spree/stock/prioritizer'
require 'spree/stock/quantifier'
require 'spree/stock/shipping_rate_selector'
require 'spree/stock/shipping_rate_sorter'
require 'spree/stock/splitter/base'
require 'spree/stock/splitter/backordered'
require 'spree/stock/splitter/shipping_category'
require 'spree/stock/splitter/weight'
require 'spree/stock_transfer'
require 'spree/transfer_item'
require 'spree/unit_cancel'
require 'spree/user_address'
require 'spree/user_stock_location'
require 'spree/variant/price_selector'
require 'spree/variant/pricing_options'
require 'spree/variant_property_rule'
require 'spree/variant_property_rule_condition'
require 'spree/variant_property_rule_value'
require 'spree/variant/scopes'
require 'spree/variant/vat_price_generator'
require 'spree/wallet'
require 'spree/wallet/add_payment_sources_to_wallet'
require 'spree/wallet/default_payment_builder'
require 'spree/wallet_payment_source'
require 'spree/zone'
require 'spree/zone_member'

require 'spree/app_configuration'
