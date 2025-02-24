
class ApiHeaders {
  static final Map<String, String> _baseHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': '*', // Autorise toutes les origines
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS', // Méthodes HTTP autorisées
    'Access-Control-Allow-Headers': 'Origin, Content-Type, Accept, Authorization', // En-têtes autorisés
  };

  // Méthode pour obtenir les en-têtes sans token
  static Map<String, String> getHeaders() {
    return _baseHeaders;
  }

  // Méthode pour obtenir les en-têtes avec token
  static Map<String, String> getHeadersWithToken(String token) {
    return {
      ..._baseHeaders, // ajoute les en-têtes de base
      'Authorization': 'Bearer $token', // ajoute le token
    };
  }
}
