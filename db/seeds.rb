# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# user = User.create(email: "kapil.patel@codiatic.com", password: 123456, password_confirmation: 123456)
# user.add_role :admin
# user = User.create(email: "aakash.kushwah@codiatic.com", password: 123456, password_confirmation: 123456)
# user.add_role :seller
# category = Category.create(name: "Mobiles")
# product = category.products.create(name: "MOTOROLA g54 5G (Pearl Blue, 128 GB)  (8 GB RAM)", price: 17999.00, description: "Stay productive and improve your performance with this resourceful smartphone that has a myriad of features to its name. With 8 GB RAM and 128 GB storage, you can seamlessly perform a multitude of tasks at ease and stack up a heap of content with the huge storage space. The 7020 octa-core MediaTek Dimensity processor delivers a power-packed performance. The 50 MP OIS camera is equipped with Quad Pixel technology and the 16 MP front camera lets you cherish your photography experience. Powered by a 6000 mAh battery supported with a 33 W charger, you can use this mobile for hours together without fearing power drop. With 14 5G bands, experience superfast network connectivity. Experience immersive entertainment with the 120 Hz with 16.6 cm FHD+ Display. Featuring a premium glass finish, stereo speakers with Dolby Atmos and Moto Spatial sound, IP52 rating, this phone lets you have an incredible experience.", brand: "MOTOROLA", stock_quantity: 40, user_id: 2)
