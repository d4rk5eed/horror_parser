require 'spec_helper'

describe "User" do
  let!(:user) {
    User.create(tags: ["a", "b", "c"])
  }
  it ".find_by_tags" do
    expect(User.by_tags(["b", "c", "d"]).last).to eq(user)
  end
end
