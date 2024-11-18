class Location {
  final String region;
  final String departamentoCode;
  final String departamento;
  final String municipioCode;
  final String municipio;

  Location({
    required this.region,
    required this.departamentoCode,
    required this.departamento,
    required this.municipioCode,
    required this.municipio,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      region: json['region'],
      departamentoCode: json['c_digo_dane_del_departamento'],
      departamento: json['departamento'],
      municipioCode: json['c_digo_dane_del_municipio'],
      municipio: json['municipio'],
    );
  }
}
