class ApiResponse<T>{
   final errorMessage;
   String status;
   T data;

   ApiResponse({required this.errorMessage, required this.status, required this.data});
   factory ApiResponse.fromJson(Map<String, dynamic> json){
     return ApiResponse(
         errorMessage: json["errorMessage"],
         status: json["responseStatus"],
         data: json["data"],
     );
   }
}