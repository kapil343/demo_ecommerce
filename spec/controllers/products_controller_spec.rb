require 'rails_helper'

# RSpec.describe ProductsController, type: :controller do
#   describe "GET #index" do
#     let(:user) { create :user }
#     let(:product) { create(:product) }
#     before do
#       get :index
#     end

#     before do
#       allow(controller).to receive(:current_user).and_return(user)
#     end

#     context "as a seller" do
#       before do
#         user.add_role :seller
#       end

#       it "assigns all the products belonging to the current_user " do
#         product = create(:product, user: user)
#         expect(assigns(:products)).to include(product)
#       end

#       it "assigns @q(search result) with current_user's products" do
#         expect(assigns(:q).result).to eq(user.products)
#       end
#     end

#     context "with category_id" do
#       let(:category) { create :category }

#       it "assigns products with given category_id" do
#         product = create(:product, category: category)
#         get :index, params: {category_id: category.id}
#         expect(assigns(:products)).to include(product)
#       end

#       it "assigns @q(search results) with products filtered by category_id" do
#         product = create(:product, category: category)
#         product2 = create(:product, category: category)
#         get :index, params: {category_id: category.id}
#         expect(assigns(:q).result).to eq(Product.where(category: category))
#       end
#     end

#     context "without current_user and category_id" do
#       it "assigns all products" do
#         expect(assigns(:products)).to eq([product])
#       end

#       it "assigns @q with all products" do
#         expect(assigns(:q).result).to eq(Product.all)
#       end

#       it "responds successfully" do
#         expect(response).to be_successful
#       end

#       it "renders the index template" do
#         expect(response).to render_template(:index)
#       end

#       it "returns the status code ok" do
#         expect(response).to have_http_status(:ok)
#       end
#     end

#     it "responds to csv format" do
#       get :index, format: :csv
#       expect(response).to be_successful
#       expect(response.headers["Content-Type"]).to eq("text/csv")
#       expect(response.headers["Content-Disposition"]).to include("filename=\"products.csv\"")
#     end
#   end

#   describe "GET #new" do
#     let(:user) { create(:user) }

#     before do
#       allow(controller).to receive(:current_user).and_return(user)
#     end

#     it "assigns a new product to @product" do
#       get :new
#       expect(assigns(:product)).to be_a_new(Product)
#     end

#     it "builds a product belonging to the current user" do
#       get :new
#       expect(assigns(:product).user).to eq(user)
#     end

#     it "renders the new template" do
#       get :new
#       expect(response).to render_template(:new)
#     end
#   end
# end

RSpec.describe ProductsController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create :category }
  let(:product) { create(:product) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe "GET #index" do
    it "assigns @products" do
      get :index
      expect(assigns(:products)).not_to be_nil
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "responds successfully" do
      get :index
      expect(response).to be_successful
    end

    it "responds to html format" do
      get :index
      expect(response.content_type).to eq "text/html; charset=utf-8"
    end

    it "responds to csv format" do
      get :index, format: :csv
      expect(response.content_type).to eq "text/csv"
    end
  end

  describe "GET #new" do
    it "assigns a new product to @product" do
      get :new
      expect(assigns(:product)).to be_a_new(Product)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new product" do
        post :create, params: { product: product_params }
        expect(Product.count).to change.by(1)
      end

      it "redirects to products path" do
        post :create, params: { product: product_params }
        byebug
        expect(response).to redirect_to(product)
      end
    end

    context "with invalid params" do
      it "does not create a new product" do
        expect {
          post :create, params: { product: attributes_for(:product, name: nil) }
        }.not_to change(Product, :count)
      end

      it "renders the new template" do
        post :create, params: { product: attributes_for(:product, name: nil) }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested product to @product" do
      get :show, params: { id: product.id }
      expect(assigns(:product)).to eq(product)
    end

    it "renders the show template" do
      get :show, params: { id: product.id }
      expect(response).to render_template(:show)
    end
  end

  describe "GET #edit" do
    it "assigns the requested product to @product" do
      get :edit, params: { id: product.id }
      expect(assigns(:product)).to eq(product)
    end

    it "renders the edit template" do
      get :edit, params: { id: product.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_name) { "New Product Name" }

      it "updates the requested product" do
        put :update, params: { id: product.id, product: { name: new_name } }
        product.reload
        expect(product.name).to eq(new_name)
      end

      it "redirects to the product" do
        put :update, params: { id: product.id, product: attributes_for(:product) }
        expect(response).to redirect_to(product_path(product))
      end
    end

    context "with invalid params" do
      it "does not update the product" do
        put :update, params: { id: product.id, product: { name: nil } }
        product.reload
        expect(product.name).not_to be_nil
      end

      it "renders the edit template" do
        put :update, params: { id: product.id, product: { name: nil } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested product" do
      product_to_destroy = create(:product, user: user)
      expect {
        delete :destroy, params: { id: product_to_destroy.id }
      }.to change(Product, :count).by(-1)
    end

    it "redirects to the products list" do
      delete :destroy, params: { id: product.id }
      expect(response).to redirect_to(products_path)
    end
  end
end

def product_params
  # sequence(:name) { |n| "Product #{n}" }
  {
  name: "product1",
  price: 100,
  description: "Product description",
  brand: "Brand",
  stock_quantity: 10
}
  # association :user
  # association :category
end
