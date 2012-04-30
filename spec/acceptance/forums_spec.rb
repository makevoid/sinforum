require_relative "spec_helper"

describe "Forum" do
  let(:forum){ Forum.create name: "foro"  }
  let(:post){ forum.posts.create title: "one", text: "one", user_id: user.id  }

  before :all do
    forum
  end

  it "GET /forums" do
    get "/forums"
    body.should include(forum.name)
  end

  it "GET /forum" do
    get "/forums/#{forum.id}"
    body.should include(forum.name)
  end

  it "GET /forum/new" do
    get "/forums/new"
  end

  after :all do
    clear_db
  end

end