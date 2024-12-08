class ProductData {
  List<Documents>? documents;

  ProductData({this.documents});

  ProductData.fromJson(Map<String, dynamic> json) {
    if (json['documents'] != null) {
      documents = <Documents>[];
      json['documents'].forEach((v) {
        documents!.add(Documents.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (documents != null) {
      data['documents'] = documents!.map((v) => v.toJson()).toList();
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
    fields = json['fields'] != null ? Fields.fromJson(json['fields']) : null;
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }

  get stringValue => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    if (fields != null) {
      data['fields'] = fields!.toJson();
    }
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
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
  Description? userId;

  Fields(
      {this.description,
      this.id,
      this.price,
      this.title,
      this.imageUrl,
      this.companyName,
      this.country,
      this.userId,
      this.quantity});

  Fields.fromJson(Map<String, dynamic> json) {
    description = json['description'] != null
        ? Description.fromJson(json['description'])
        : null;
    id = json['id'] != null ? Description.fromJson(json['id']) : null;
    price = json['price'] != null ? Description.fromJson(json['price']) : null;
    title = json['title'] != null ? Description.fromJson(json['title']) : null;
    imageUrl = json['image_url'] != null
        ? Description.fromJson(json['image_url'])
        : null;
    companyName = json['company_name'] != null
        ? Description.fromJson(json['company_name'])
        : null;
    country =
        json['country'] != null ? Description.fromJson(json['country']) : null;
    quantity = json['quantity'] != null
        ? Description.fromJson(json['quantity'])
        : null;
    if (json['userId'] != null) {
      userId = Description.fromJson(json['userId']);
    } else {
      userId = null; // Explicitly set userId to null if it's missing
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (description != null) {
      data['description'] = description!.toJson();
    }
    if (id != null) {
      data['id'] = id!.toJson();
    }
    if (price != null) {
      data['price'] = price!.toJson();
    }
    if (title != null) {
      data['title'] = title!.toJson();
    }
    if (imageUrl != null) {
      data['image_url'] = imageUrl!.toJson();
    }
    if (companyName != null) {
      data['company_name'] = companyName!.toJson();
    }
    if (country != null) {
      data['country'] = country!.toJson();
    }
    if (quantity != null) {
      data['quantity'] = quantity!.toJson();
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
    data['stringValue'] = stringValue;
    return data;
  }
}
