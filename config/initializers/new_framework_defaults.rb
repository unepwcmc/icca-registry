# belongs_to will now trigger a validation error by default if the association is not present.

# This can be turned off per-association with optional: true.
Rails.application.config.active_record.belongs_to_required_by_default = true
