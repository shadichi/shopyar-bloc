import '../../../../core/params/home_user_data_params.dart';
import '../../../../core/params/products_params.dart';
import '../../../../core/usecases/get_string_use_case.dart';
import '../repository/product_repository.dart';

class ProductsGetStringDataUseCase extends getStringUseCase<InfParams> {
  final ProductRepository _productRepository;
  ProductsGetStringDataUseCase(this._productRepository);

  @override
  Future<InfParams> call() {
    return _productRepository.getString();
  }
}