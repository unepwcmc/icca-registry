class AddNotNullConstraintToDateNotNullTags < ActiveRecord::Migration[5.2]
  def up
    ActiveRecord::Base.connection.execute(
      <<-SQL
          -- Make sure existing date_not_null fragments all have a not NULL datetime
          UPDATE comfy_cms_fragments
          SET datetime = CURRENT_TIMESTAMP
          WHERE tag = 'date_not_null' AND datetime IS NULL;

          -- Make sure there are no date_not_null fragments with NULL datetime
          ALTER TABLE comfy_cms_fragments
          ADD CONSTRAINT date_not_null CHECK (
            NOT ( tag = 'date_not_null' AND datetime IS NULL )
          );
        SQL
    )
  end

  def down
    ActiveRecord::Base.connection.execute(
      <<-SQL
          ALTER TABLE comfy_cms_fragments
          DROP CONSTRAINT date_not_null,
        SQL
    )
  end
end
