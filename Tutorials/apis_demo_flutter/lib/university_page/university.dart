class University {
  String? alphaTwoCode;
  List<String>? webPages;
  String? country;
  List<String>? domains;
  String? name;
  String? stateProvince;

  University({
    this.alphaTwoCode,
    this.webPages,
    this.country,
    this.domains,
    this.name,
    this.stateProvince,
  });

  University.fromJson(Map<String, dynamic> json) {
    alphaTwoCode = json['alpha_two_code'];
    webPages = json['web_pages'].cast<String>();
    country = json['country'];
    domains = json['domains'].cast<String>();
    name = json['name'];
    stateProvince = json['state-province'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alpha_two_code'] = alphaTwoCode;
    data['web_pages'] = webPages;
    data['country'] = country;
    data['domains'] = domains;
    data['name'] = name;
    data['state-province'] = stateProvince;
    return data;
  }
}