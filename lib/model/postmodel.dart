class ProductData {
  List<Documents>? documents;

  ProductData({this.documents});

  ProductData.fromJson(Map<String, dynamic> json) {
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
  Description? description;
  Description? id;
  Description? price;
  Description? title;
  Description? imageUrl;
  Description? companyName;
  Description? country;
  Description? quantity;

  Fields(
      {this.description,
      this.id,
      this.price,
      this.title,
      this.imageUrl,
      this.companyName,
      this.country,
      this.quantity});

  Fields.fromJson(Map<String, dynamic> json) {
    description = json['description'] != null
        ? new Description.fromJson(json['description'])
        : null;
    id = json['id'] != null ? new Description.fromJson(json['id']) : null;
    price =
        json['price'] != null ? new Description.fromJson(json['price']) : null;
    title =
        json['title'] != null ? new Description.fromJson(json['title']) : null;
    imageUrl = json['image_url'] != null
        ? new Description.fromJson(json['image_url'])
        : null;
    companyName = json['company_name'] != null
        ? new Description.fromJson(json['company_name'])
        : null;
    country = json['country'] != null
        ? new Description.fromJson(json['country'])
        : null;
    quantity = json['quantity'] != null
        ? new Description.fromJson(json['quantity'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.description != null) {
      data['description'] = this.description!.toJson();
    }
    if (this.id != null) {
      data['id'] = this.id!.toJson();
    }
    if (this.price != null) {
      data['price'] = this.price!.toJson();
    }
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    if (this.imageUrl != null) {
      data['image_url'] = this.imageUrl!.toJson();
    }
    if (this.companyName != null) {
      data['company_name'] = this.companyName!.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    if (this.quantity != null) {
      data['quantity'] = this.quantity!.toJson();
    }
    return data;
  }
}

class Description {
  String? stringValue;

  Description({this.stringValue});

  Description.fromJson(Map<String, dynamic> json) {
    stringValue = json['stringValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['stringValue'] = this.stringValue;
    return data;
  }
}
