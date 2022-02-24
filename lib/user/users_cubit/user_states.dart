abstract class UserStates {}

class UserInitialStates extends UserStates {}

class UserChangeBottomNavSuccessStates extends UserStates {}

class UserIncrementCountStates extends UserStates {}

class UserDecrementCountStates extends UserStates {}

/* Categories States */

// Get Categories
class UserGetAllCategoriesLoadingStates extends UserStates {}

class UserGetAllCategoriesSuccessStates extends UserStates {}

class UserGetAllCategoriesErrorStates extends UserStates {}

// search categories

class UserSearchCategoriesLoadingStates extends UserStates {}

class UserSearchCategoriesSuccessStates extends UserStates {}

class UserSearchCategoriesErrorStates extends UserStates {}

// ******************************************************************//

/* Products States */

// Get All Products

class UserGetAllProductsLoadingStates extends UserStates {}

class UserGetAllProductssSuccessStates extends UserStates {}

class UserGetAllProductsErrorStates extends UserStates {}

class UserGetProductsOfCategoryLoadingStates extends UserStates {}

class UserGetProductsOfCategorySuccessStates extends UserStates {}

class UserGetProductsOfCategoryErrorStates extends UserStates {}

class UserGetFavDataLoadingStates extends UserStates {}

class UserGetFavDataSuccessStates extends UserStates {}

class UserGetFavDatarrorStates extends UserStates {}

//Update favouriteProduct

class UserUpdateFavProductsLoadingStates extends UserStates {}

class UserUpdateFavProductsSuccessStates extends UserStates {}

class UserUpdateFavProductsErrorStates extends UserStates {}

class UserUpdateCartProductsLoadingStates extends UserStates {}

class UserUpdateCartProductsSuccessStates extends UserStates {}

class UserUpdateCartProductsErrorStates extends UserStates {}

//add favourite products

class UserAddFavProductsLoadingStates extends UserStates {}

class UserAddFavProductsSuccessStates extends UserStates {}

class UserAddFavProductsErrorStates extends UserStates {}

class UserRemoveFromFavStates extends UserStates {}

class UserGetFavProductsLoadingStates extends UserStates {}

class UserGetFavProductsSuccessStates extends UserStates {}

class UserGetFavProductsErrorStates extends UserStates {}

//add cart products

class UserAddCartProductsLoadingStates extends UserStates {}

class UserAddCartProductsSuccessStates extends UserStates {}

class UserAddCartProductsErrorStates extends UserStates {}

class UserRemoveFromCartsStates extends UserStates {}

class UserGetCartsProductsLoadingStates extends UserStates {}

class UserGetCartsProductsSuccessStates extends UserStates {}

class UserGetCartsProductsErrorStates extends UserStates {}

// search proucts

class UserSearchProductsLoadingStates extends UserStates {}

class UserSearchProductsSuccessStates extends UserStates {}

class UserSearchProductsErrorStates extends UserStates {}

//search fav product

class UserSearchFavProductsLoadingStates extends UserStates {}

class UserSearchFavSuccessStates extends UserStates {}

class UserSearchFavErrorStates extends UserStates {}

// Make Order

class UserMakeOrderLoadingStates extends UserStates {}

class UserMakeOrderSuccessStates extends UserStates {}

class UserMakeOrderErrorStates extends UserStates {}

class UserGetOneUserLoadingStates extends UserStates {}

class UserGetOneUserSuccessStates extends UserStates {}

class UserGetOneUserErrorStates extends UserStates {}

class UserToggleThemeData extends UserStates {}
