require "spec_helper"

describe Releaf do
  describe ".available_controllers" do
    it "returns all available controllers" do
      expect(Releaf.available_controllers).to eq(["releaf/content/nodes", "admin/books", "admin/authors",
                                                  "admin/publishers",
                                                  "releaf/permissions/users", "releaf/permissions/roles",
                                                  "releaf/core/settings", "releaf/i18n_database/translations",
                                                  "admin/chapters", "releaf/permissions/profile"])
    end
  end
end
