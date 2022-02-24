abstract class AdminStates {}

class AdminInitialStates extends AdminStates {}

//**********************************************************************/
//Product States

/* --  Add Product --   */
class AdminAddProductLoadingStates extends AdminStates {}

class AdminAddProductSuccessStates extends AdminStates {}

class AdminAddProductErrorStates extends AdminStates {}

class AdminPickProductImageSuccessStates extends AdminStates {}

class AdminPickProductImageErrorStates extends AdminStates {
  final error;
  AdminPickProductImageErrorStates(this.error);
}
/******************************************************************* */

/* --  Edit Product --   */
class AdminEditProductLoadingStates extends AdminStates {}

class AdminEditProductSuccessStates extends AdminStates {}

class AdminEditProductErrorStates extends AdminStates {}

class SocialUploadProductImageSuccessState extends AdminStates {}

class SocialUploadProductImageErrorState extends AdminStates {}

/* --  Delete Product --   */
class AdminDeleteProductLoadingStates extends AdminStates {}

class AdminDeleteProductSuccessStates extends AdminStates {}

class AdminDeleteProductErrorStates extends AdminStates {}

/* --  Get All Products --   */

class AdminGetAllProductsLoadingStates extends AdminStates {}

class AdminGetAllProductsSuccessStates extends AdminStates {}

class AdminGetAllProductsErrorStates extends AdminStates {}

//**********************************************************************/

//Category States

/* --  Add Category --   */

class AdminAddCategoryLoadingStates extends AdminStates {}

class AdminAddCategorySuccessStates extends AdminStates {}

class AdminAddCategoryErrorStates extends AdminStates {}

class AdminPickCategoryImageSuccessStates extends AdminStates {}

class AdminPickCategoryImageErrorStates extends AdminStates {
  final error;
  AdminPickCategoryImageErrorStates(this.error);
}

class AdminAddExistCategoryErrorStates extends AdminStates {
  final error;
  AdminAddExistCategoryErrorStates(this.error);
}

/* --  Get All Categories --   */

class AdminGetAllCategoryLoadingStates extends AdminStates {}

class AdminGetAllCategorySuccessStates extends AdminStates {}

class AdminGetAllCategoryErrorStates extends AdminStates {}

class AdminGetCatByNameSuccessStates extends AdminStates {}

/* --  Edit Category --   */

class AdminEditCategoryLoadingStates extends AdminStates {}

class AdminEditCategorySuccessStates extends AdminStates {}

class AdminEditCategoryErrorStates extends AdminStates {}

//**********************************************************************/
class AdminGetAllUsersLoadingStates extends AdminStates {}

class AdminGetAllUsersSuccessStates extends AdminStates {}

class AdminGetAllUsersErrorStates extends AdminStates {}

class AdminGetAllOrdersLoadingStates extends AdminStates {}

class AdminGetAllOrdersSuccessStates extends AdminStates {}

class AdminGetAllOrdersErrorStates extends AdminStates {}
