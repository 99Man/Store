class product_data {
  List<Documents>? documents;

  product_data({this.documents});

  product_data.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(new Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.documents != null) {
      data['documents'] = this.documents!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Documents {
  String? name;
  Fields? fields;
  String? createTime;
  String? updateTime;

  Documents({this.name, this.fields, this.createTime, this.updateTime});

  Documents.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    fields =
        json['fields'] != null ? new Fields.fromJson(json['fields']) : null;
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.fields != null) {
      data['fields'] = this.fields!.toJson();
    }
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    return data;
  }
}

class Fields {
  Id? id;
  Id? description;
  Id? companyName;
  Id? title;
  Id? price;
  Id? country;
  Id? imageUrl;
  Id? quantity;

  Fields(
      {this.id,
      this.description,
      this.companyName,
      this.title,
      this.price,
      this.country,
      this.imageUrl,
      this.quantity});

  Fields.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? new Id.fromJson(json['id']) : null;
    description = json['description'] != null
        ? new Id.fromJson(json['description'])
        : null;
    companyName = json['company_name'] != null
        ? new Id.fromJson(json['company_name'])
        : null;
    title = json['title'] != null ? new Id.fromJson(json['title']) : null;
    price = json['price'] != null ? new Id.fromJson(json['price']) : null;
    country = json['country'] != null ? new Id.fromJson(json['country']) : null;
    imageUrl =
        json['image_url'] != null ? new Id.fromJson(json['image_url']) : null;
    quantity =
        json['quantity'] != null ? new Id.fromJson(json['quantity']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.id != null) {
      data['id'] = this.id!.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description!.toJson();
    }
    if (this.companyName != null) {
      data['company_name'] = this.companyName!.toJson();
    }
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    if (this.price != null) {
      data['price'] = this.price!.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.imageUrl != null) {
      data['image_url'] = this.imageUrl!.toJson();
    }
    if (this.quantity != null) {
      data['quantity'] = this.quantity!.toJson();
    }
    return data;
  }
}

class Id {
  String? stringValue;

  Id({this.stringValue});

  Id.fromJson(Map<String, dynamic> json) {
    stringValue = json['stringValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stringValue'] = this.stringValue;
    return data;
  }
}
