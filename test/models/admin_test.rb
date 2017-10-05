require 'test_helper'

class AdminTest < ActiveSupport::TestCase

  test "should not save admin without issupper" do
    @admin = Admin.new(email:'a@b.c', name: 'a', password_digest: '12332')
    assert_not @admin.save, "Saved the admin without a issupper"
  end

  test "should not save admin without name" do
    @admin = Admin.new(email:'a@b.c', password_digest: '12332',issuper:1)
    assert_not @admin.save, "Saved the admin without a licencePlateNum"
  end

  test "should not save admin without email" do
    @admin = Admin.new(name: 'a', password_digest: '12332', issuper:1)
    assert_not @admin.save, "Saved the admin without a manufacturer"
  end

  test "should not save admin without password_digest" do
    @admin = Admin.new(name: 'a', email: 'a@b.c', issuper:1)
    assert_not @admin.save, "Saved the admin without a model"
  end

end
