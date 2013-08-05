require 'spec_helper'
describe "Errors feature" do
  before do
    auth_as_admin
  end

  it "return 404 status code and generic error page for unexisting rotues" do
    visit(releaf_root_path + "/asdassd")

    expect(page.status_code).to eq(404)
    expect(page.body).to match(/not found/)
  end

  it "return 403 status code and generic error page for restricted content" do
    Releaf::Role.any_instance.stub(:authorize!).and_return(false)
    visit releaf_roles_path

    expect(page.status_code).to eq(403)
    expect(page.body).to match(/you are not authorized to access roles/i)
  end
end