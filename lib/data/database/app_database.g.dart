// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ClothingItemsTable extends ClothingItems with TableInfo<$ClothingItemsTable, ClothingItem>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$ClothingItemsTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _imagePathMeta = const VerificationMeta('imagePath');
@override
late final GeneratedColumn<String> imagePath = GeneratedColumn<String>('image_path', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _categoryMeta = const VerificationMeta('category');
@override
late final GeneratedColumn<String> category = GeneratedColumn<String>('category', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _subcategoryMeta = const VerificationMeta('subcategory');
@override
late final GeneratedColumn<String> subcategory = GeneratedColumn<String>('subcategory', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _colorMeta = const VerificationMeta('color');
@override
late final GeneratedColumn<String> color = GeneratedColumn<String>('color', aliasedName, true, type: DriftSqlType.string, requiredDuringInsert: false);
static const VerificationMeta _seasonsMeta = const VerificationMeta('seasons');
@override
late final GeneratedColumnWithTypeConverter<List<String>, String> seasons = GeneratedColumn<String>('seasons', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant('[]')).withConverter<List<String>>($ClothingItemsTable.$converterseasons);
static const VerificationMeta _styleTagsMeta = const VerificationMeta('styleTags');
@override
late final GeneratedColumnWithTypeConverter<List<String>, String> styleTags = GeneratedColumn<String>('style_tags', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant('[]')).withConverter<List<String>>($ClothingItemsTable.$converterstyleTags);
static const VerificationMeta _weatherTagsMeta = const VerificationMeta('weatherTags');
@override
late final GeneratedColumnWithTypeConverter<List<String>, String> weatherTags = GeneratedColumn<String>('weather_tags', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant('[]')).withConverter<List<String>>($ClothingItemsTable.$converterweatherTags);
static const VerificationMeta _sortOrderMeta = const VerificationMeta('sortOrder');
@override
late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>('sort_order', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: const Constant(0));
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: false, defaultValue: currentDateAndTime);
@override
List<GeneratedColumn> get $columns => [id, imagePath, category, subcategory, color, seasons, styleTags, weatherTags, sortOrder, createdAt];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'clothing_items';
@override
VerificationContext validateIntegrity(Insertable<ClothingItem> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));} else if (isInserting) {
context.missing(_idMeta);
}
if (data.containsKey('image_path')) {
context.handle(_imagePathMeta, imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta));} else if (isInserting) {
context.missing(_imagePathMeta);
}
if (data.containsKey('category')) {
context.handle(_categoryMeta, category.isAcceptableOrUnknown(data['category']!, _categoryMeta));} else if (isInserting) {
context.missing(_categoryMeta);
}
if (data.containsKey('subcategory')) {
context.handle(_subcategoryMeta, subcategory.isAcceptableOrUnknown(data['subcategory']!, _subcategoryMeta));}if (data.containsKey('color')) {
context.handle(_colorMeta, color.isAcceptableOrUnknown(data['color']!, _colorMeta));}context.handle(_seasonsMeta, const VerificationResult.success());context.handle(_styleTagsMeta, const VerificationResult.success());context.handle(_weatherTagsMeta, const VerificationResult.success());if (data.containsKey('sort_order')) {
context.handle(_sortOrderMeta, sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));}if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));}return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {id};
@override ClothingItem map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return ClothingItem(id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!, imagePath: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}image_path'])!, category: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}category'])!, subcategory: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}subcategory']), color: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}color']), seasons: $ClothingItemsTable.$converterseasons.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}seasons'])!), styleTags: $ClothingItemsTable.$converterstyleTags.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}style_tags'])!), weatherTags: $ClothingItemsTable.$converterweatherTags.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}weather_tags'])!), sortOrder: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!, createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, );
}
@override
$ClothingItemsTable createAlias(String alias) {
return $ClothingItemsTable(attachedDatabase, alias);}static TypeConverter<List<String>,String> $converterseasons = const StringListConverter();static TypeConverter<List<String>,String> $converterstyleTags = const StringListConverter();static TypeConverter<List<String>,String> $converterweatherTags = const StringListConverter();}class ClothingItem extends DataClass implements Insertable<ClothingItem> 
{
final String id;
final String imagePath;
final String category;
final String? subcategory;
final String? color;
final List<String> seasons;
final List<String> styleTags;
final List<String> weatherTags;
final int sortOrder;
final DateTime createdAt;
const ClothingItem({required this.id, required this.imagePath, required this.category, this.subcategory, this.color, required this.seasons, required this.styleTags, required this.weatherTags, required this.sortOrder, required this.createdAt});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<String>(id);
map['image_path'] = Variable<String>(imagePath);
map['category'] = Variable<String>(category);
if (!nullToAbsent || subcategory != null){map['subcategory'] = Variable<String>(subcategory);
}if (!nullToAbsent || color != null){map['color'] = Variable<String>(color);
}{map['seasons'] = Variable<String>($ClothingItemsTable.$converterseasons.toSql(seasons));
}{map['style_tags'] = Variable<String>($ClothingItemsTable.$converterstyleTags.toSql(styleTags));
}{map['weather_tags'] = Variable<String>($ClothingItemsTable.$converterweatherTags.toSql(weatherTags));
}map['sort_order'] = Variable<int>(sortOrder);
map['created_at'] = Variable<DateTime>(createdAt);
return map; 
}
ClothingItemsCompanion toCompanion(bool nullToAbsent) {
return ClothingItemsCompanion(id: Value(id),imagePath: Value(imagePath),category: Value(category),subcategory: subcategory == null && nullToAbsent ? const Value.absent() : Value(subcategory),color: color == null && nullToAbsent ? const Value.absent() : Value(color),seasons: Value(seasons),styleTags: Value(styleTags),weatherTags: Value(weatherTags),sortOrder: Value(sortOrder),createdAt: Value(createdAt),);
}
factory ClothingItem.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return ClothingItem(id: serializer.fromJson<String>(json['id']),imagePath: serializer.fromJson<String>(json['imagePath']),category: serializer.fromJson<String>(json['category']),subcategory: serializer.fromJson<String?>(json['subcategory']),color: serializer.fromJson<String?>(json['color']),seasons: serializer.fromJson<List<String>>(json['seasons']),styleTags: serializer.fromJson<List<String>>(json['styleTags']),weatherTags: serializer.fromJson<List<String>>(json['weatherTags']),sortOrder: serializer.fromJson<int>(json['sortOrder']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<String>(id),'imagePath': serializer.toJson<String>(imagePath),'category': serializer.toJson<String>(category),'subcategory': serializer.toJson<String?>(subcategory),'color': serializer.toJson<String?>(color),'seasons': serializer.toJson<List<String>>(seasons),'styleTags': serializer.toJson<List<String>>(styleTags),'weatherTags': serializer.toJson<List<String>>(weatherTags),'sortOrder': serializer.toJson<int>(sortOrder),'createdAt': serializer.toJson<DateTime>(createdAt),};}ClothingItem copyWith({String? id,String? imagePath,String? category,Value<String?> subcategory = const Value.absent(),Value<String?> color = const Value.absent(),List<String>? seasons,List<String>? styleTags,List<String>? weatherTags,int? sortOrder,DateTime? createdAt}) => ClothingItem(id: id ?? this.id,imagePath: imagePath ?? this.imagePath,category: category ?? this.category,subcategory: subcategory.present ? subcategory.value : this.subcategory,color: color.present ? color.value : this.color,seasons: seasons ?? this.seasons,styleTags: styleTags ?? this.styleTags,weatherTags: weatherTags ?? this.weatherTags,sortOrder: sortOrder ?? this.sortOrder,createdAt: createdAt ?? this.createdAt,);ClothingItem copyWithCompanion(ClothingItemsCompanion data) {
return ClothingItem(
id: data.id.present ? data.id.value : this.id,imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,category: data.category.present ? data.category.value : this.category,subcategory: data.subcategory.present ? data.subcategory.value : this.subcategory,color: data.color.present ? data.color.value : this.color,seasons: data.seasons.present ? data.seasons.value : this.seasons,styleTags: data.styleTags.present ? data.styleTags.value : this.styleTags,weatherTags: data.weatherTags.present ? data.weatherTags.value : this.weatherTags,sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,);
}
@override
String toString() {return (StringBuffer('ClothingItem(')..write('id: $id, ')..write('imagePath: $imagePath, ')..write('category: $category, ')..write('subcategory: $subcategory, ')..write('color: $color, ')..write('seasons: $seasons, ')..write('styleTags: $styleTags, ')..write('weatherTags: $weatherTags, ')..write('sortOrder: $sortOrder, ')..write('createdAt: $createdAt')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, imagePath, category, subcategory, color, seasons, styleTags, weatherTags, sortOrder, createdAt);@override
bool operator ==(Object other) => identical(this, other) || (other is ClothingItem && other.id == this.id && other.imagePath == this.imagePath && other.category == this.category && other.subcategory == this.subcategory && other.color == this.color && other.seasons == this.seasons && other.styleTags == this.styleTags && other.weatherTags == this.weatherTags && other.sortOrder == this.sortOrder && other.createdAt == this.createdAt);
}class ClothingItemsCompanion extends UpdateCompanion<ClothingItem> {
final Value<String> id;
final Value<String> imagePath;
final Value<String> category;
final Value<String?> subcategory;
final Value<String?> color;
final Value<List<String>> seasons;
final Value<List<String>> styleTags;
final Value<List<String>> weatherTags;
final Value<int> sortOrder;
final Value<DateTime> createdAt;
final Value<int> rowid;
const ClothingItemsCompanion({this.id = const Value.absent(),this.imagePath = const Value.absent(),this.category = const Value.absent(),this.subcategory = const Value.absent(),this.color = const Value.absent(),this.seasons = const Value.absent(),this.styleTags = const Value.absent(),this.weatherTags = const Value.absent(),this.sortOrder = const Value.absent(),this.createdAt = const Value.absent(),this.rowid = const Value.absent(),});
ClothingItemsCompanion.insert({required String id,required String imagePath,required String category,this.subcategory = const Value.absent(),this.color = const Value.absent(),this.seasons = const Value.absent(),this.styleTags = const Value.absent(),this.weatherTags = const Value.absent(),this.sortOrder = const Value.absent(),this.createdAt = const Value.absent(),this.rowid = const Value.absent(),}): id = Value(id), imagePath = Value(imagePath), category = Value(category);
static Insertable<ClothingItem> custom({Expression<String>? id, 
Expression<String>? imagePath, 
Expression<String>? category, 
Expression<String>? subcategory, 
Expression<String>? color, 
Expression<String>? seasons, 
Expression<String>? styleTags, 
Expression<String>? weatherTags, 
Expression<int>? sortOrder, 
Expression<DateTime>? createdAt, 
Expression<int>? rowid, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (imagePath != null)'image_path': imagePath,if (category != null)'category': category,if (subcategory != null)'subcategory': subcategory,if (color != null)'color': color,if (seasons != null)'seasons': seasons,if (styleTags != null)'style_tags': styleTags,if (weatherTags != null)'weather_tags': weatherTags,if (sortOrder != null)'sort_order': sortOrder,if (createdAt != null)'created_at': createdAt,if (rowid != null)'rowid': rowid,});
}ClothingItemsCompanion copyWith({Value<String>? id, Value<String>? imagePath, Value<String>? category, Value<String?>? subcategory, Value<String?>? color, Value<List<String>>? seasons, Value<List<String>>? styleTags, Value<List<String>>? weatherTags, Value<int>? sortOrder, Value<DateTime>? createdAt, Value<int>? rowid}) {
return ClothingItemsCompanion(id: id ?? this.id,imagePath: imagePath ?? this.imagePath,category: category ?? this.category,subcategory: subcategory ?? this.subcategory,color: color ?? this.color,seasons: seasons ?? this.seasons,styleTags: styleTags ?? this.styleTags,weatherTags: weatherTags ?? this.weatherTags,sortOrder: sortOrder ?? this.sortOrder,createdAt: createdAt ?? this.createdAt,rowid: rowid ?? this.rowid,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<String>(id.value);}
if (imagePath.present) {
map['image_path'] = Variable<String>(imagePath.value);}
if (category.present) {
map['category'] = Variable<String>(category.value);}
if (subcategory.present) {
map['subcategory'] = Variable<String>(subcategory.value);}
if (color.present) {
map['color'] = Variable<String>(color.value);}
if (seasons.present) {
map['seasons'] = Variable<String>($ClothingItemsTable.$converterseasons.toSql(seasons.value));}
if (styleTags.present) {
map['style_tags'] = Variable<String>($ClothingItemsTable.$converterstyleTags.toSql(styleTags.value));}
if (weatherTags.present) {
map['weather_tags'] = Variable<String>($ClothingItemsTable.$converterweatherTags.toSql(weatherTags.value));}
if (sortOrder.present) {
map['sort_order'] = Variable<int>(sortOrder.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
if (rowid.present) {
map['rowid'] = Variable<int>(rowid.value);}
return map; 
}
@override
String toString() {return (StringBuffer('ClothingItemsCompanion(')..write('id: $id, ')..write('imagePath: $imagePath, ')..write('category: $category, ')..write('subcategory: $subcategory, ')..write('color: $color, ')..write('seasons: $seasons, ')..write('styleTags: $styleTags, ')..write('weatherTags: $weatherTags, ')..write('sortOrder: $sortOrder, ')..write('createdAt: $createdAt, ')..write('rowid: $rowid')..write(')')).toString();}
}
class $OutfitsTable extends Outfits with TableInfo<$OutfitsTable, Outfit>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$OutfitsTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _nameMeta = const VerificationMeta('name');
@override
late final GeneratedColumn<String> name = GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _styleTagsMeta = const VerificationMeta('styleTags');
@override
late final GeneratedColumnWithTypeConverter<List<String>, String> styleTags = GeneratedColumn<String>('style_tags', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant('[]')).withConverter<List<String>>($OutfitsTable.$converterstyleTags);
static const VerificationMeta _weatherTagsMeta = const VerificationMeta('weatherTags');
@override
late final GeneratedColumnWithTypeConverter<List<String>, String> weatherTags = GeneratedColumn<String>('weather_tags', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: false, defaultValue: const Constant('[]')).withConverter<List<String>>($OutfitsTable.$converterweatherTags);
static const VerificationMeta _sortOrderMeta = const VerificationMeta('sortOrder');
@override
late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>('sort_order', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: const Constant(0));
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: false, defaultValue: currentDateAndTime);
@override
List<GeneratedColumn> get $columns => [id, name, styleTags, weatherTags, sortOrder, createdAt];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'outfits';
@override
VerificationContext validateIntegrity(Insertable<Outfit> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));} else if (isInserting) {
context.missing(_idMeta);
}
if (data.containsKey('name')) {
context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));} else if (isInserting) {
context.missing(_nameMeta);
}
context.handle(_styleTagsMeta, const VerificationResult.success());context.handle(_weatherTagsMeta, const VerificationResult.success());if (data.containsKey('sort_order')) {
context.handle(_sortOrderMeta, sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta));}if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));}return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {id};
@override Outfit map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return Outfit(id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!, name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!, styleTags: $OutfitsTable.$converterstyleTags.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}style_tags'])!), weatherTags: $OutfitsTable.$converterweatherTags.fromSql(attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}weather_tags'])!), sortOrder: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}sort_order'])!, createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, );
}
@override
$OutfitsTable createAlias(String alias) {
return $OutfitsTable(attachedDatabase, alias);}static TypeConverter<List<String>,String> $converterstyleTags = const StringListConverter();static TypeConverter<List<String>,String> $converterweatherTags = const StringListConverter();}class Outfit extends DataClass implements Insertable<Outfit> 
{
final String id;
final String name;
final List<String> styleTags;
final List<String> weatherTags;
final int sortOrder;
final DateTime createdAt;
const Outfit({required this.id, required this.name, required this.styleTags, required this.weatherTags, required this.sortOrder, required this.createdAt});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<String>(id);
map['name'] = Variable<String>(name);
{map['style_tags'] = Variable<String>($OutfitsTable.$converterstyleTags.toSql(styleTags));
}{map['weather_tags'] = Variable<String>($OutfitsTable.$converterweatherTags.toSql(weatherTags));
}map['sort_order'] = Variable<int>(sortOrder);
map['created_at'] = Variable<DateTime>(createdAt);
return map; 
}
OutfitsCompanion toCompanion(bool nullToAbsent) {
return OutfitsCompanion(id: Value(id),name: Value(name),styleTags: Value(styleTags),weatherTags: Value(weatherTags),sortOrder: Value(sortOrder),createdAt: Value(createdAt),);
}
factory Outfit.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return Outfit(id: serializer.fromJson<String>(json['id']),name: serializer.fromJson<String>(json['name']),styleTags: serializer.fromJson<List<String>>(json['styleTags']),weatherTags: serializer.fromJson<List<String>>(json['weatherTags']),sortOrder: serializer.fromJson<int>(json['sortOrder']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<String>(id),'name': serializer.toJson<String>(name),'styleTags': serializer.toJson<List<String>>(styleTags),'weatherTags': serializer.toJson<List<String>>(weatherTags),'sortOrder': serializer.toJson<int>(sortOrder),'createdAt': serializer.toJson<DateTime>(createdAt),};}Outfit copyWith({String? id,String? name,List<String>? styleTags,List<String>? weatherTags,int? sortOrder,DateTime? createdAt}) => Outfit(id: id ?? this.id,name: name ?? this.name,styleTags: styleTags ?? this.styleTags,weatherTags: weatherTags ?? this.weatherTags,sortOrder: sortOrder ?? this.sortOrder,createdAt: createdAt ?? this.createdAt,);Outfit copyWithCompanion(OutfitsCompanion data) {
return Outfit(
id: data.id.present ? data.id.value : this.id,name: data.name.present ? data.name.value : this.name,styleTags: data.styleTags.present ? data.styleTags.value : this.styleTags,weatherTags: data.weatherTags.present ? data.weatherTags.value : this.weatherTags,sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,);
}
@override
String toString() {return (StringBuffer('Outfit(')..write('id: $id, ')..write('name: $name, ')..write('styleTags: $styleTags, ')..write('weatherTags: $weatherTags, ')..write('sortOrder: $sortOrder, ')..write('createdAt: $createdAt')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, name, styleTags, weatherTags, sortOrder, createdAt);@override
bool operator ==(Object other) => identical(this, other) || (other is Outfit && other.id == this.id && other.name == this.name && other.styleTags == this.styleTags && other.weatherTags == this.weatherTags && other.sortOrder == this.sortOrder && other.createdAt == this.createdAt);
}class OutfitsCompanion extends UpdateCompanion<Outfit> {
final Value<String> id;
final Value<String> name;
final Value<List<String>> styleTags;
final Value<List<String>> weatherTags;
final Value<int> sortOrder;
final Value<DateTime> createdAt;
final Value<int> rowid;
const OutfitsCompanion({this.id = const Value.absent(),this.name = const Value.absent(),this.styleTags = const Value.absent(),this.weatherTags = const Value.absent(),this.sortOrder = const Value.absent(),this.createdAt = const Value.absent(),this.rowid = const Value.absent(),});
OutfitsCompanion.insert({required String id,required String name,this.styleTags = const Value.absent(),this.weatherTags = const Value.absent(),this.sortOrder = const Value.absent(),this.createdAt = const Value.absent(),this.rowid = const Value.absent(),}): id = Value(id), name = Value(name);
static Insertable<Outfit> custom({Expression<String>? id, 
Expression<String>? name, 
Expression<String>? styleTags, 
Expression<String>? weatherTags, 
Expression<int>? sortOrder, 
Expression<DateTime>? createdAt, 
Expression<int>? rowid, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (name != null)'name': name,if (styleTags != null)'style_tags': styleTags,if (weatherTags != null)'weather_tags': weatherTags,if (sortOrder != null)'sort_order': sortOrder,if (createdAt != null)'created_at': createdAt,if (rowid != null)'rowid': rowid,});
}OutfitsCompanion copyWith({Value<String>? id, Value<String>? name, Value<List<String>>? styleTags, Value<List<String>>? weatherTags, Value<int>? sortOrder, Value<DateTime>? createdAt, Value<int>? rowid}) {
return OutfitsCompanion(id: id ?? this.id,name: name ?? this.name,styleTags: styleTags ?? this.styleTags,weatherTags: weatherTags ?? this.weatherTags,sortOrder: sortOrder ?? this.sortOrder,createdAt: createdAt ?? this.createdAt,rowid: rowid ?? this.rowid,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<String>(id.value);}
if (name.present) {
map['name'] = Variable<String>(name.value);}
if (styleTags.present) {
map['style_tags'] = Variable<String>($OutfitsTable.$converterstyleTags.toSql(styleTags.value));}
if (weatherTags.present) {
map['weather_tags'] = Variable<String>($OutfitsTable.$converterweatherTags.toSql(weatherTags.value));}
if (sortOrder.present) {
map['sort_order'] = Variable<int>(sortOrder.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
if (rowid.present) {
map['rowid'] = Variable<int>(rowid.value);}
return map; 
}
@override
String toString() {return (StringBuffer('OutfitsCompanion(')..write('id: $id, ')..write('name: $name, ')..write('styleTags: $styleTags, ')..write('weatherTags: $weatherTags, ')..write('sortOrder: $sortOrder, ')..write('createdAt: $createdAt, ')..write('rowid: $rowid')..write(')')).toString();}
}
class $OutfitClothingItemsTable extends OutfitClothingItems with TableInfo<$OutfitClothingItemsTable, OutfitClothingItem>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$OutfitClothingItemsTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _outfitIdMeta = const VerificationMeta('outfitId');
@override
late final GeneratedColumn<String> outfitId = GeneratedColumn<String>('outfit_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _clothingItemIdMeta = const VerificationMeta('clothingItemId');
@override
late final GeneratedColumn<String> clothingItemId = GeneratedColumn<String>('clothing_item_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _posXMeta = const VerificationMeta('posX');
@override
late final GeneratedColumn<double> posX = GeneratedColumn<double>('pos_x', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: false, defaultValue: const Constant(0.0));
static const VerificationMeta _posYMeta = const VerificationMeta('posY');
@override
late final GeneratedColumn<double> posY = GeneratedColumn<double>('pos_y', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: false, defaultValue: const Constant(0.0));
static const VerificationMeta _scaleMeta = const VerificationMeta('scale');
@override
late final GeneratedColumn<double> scale = GeneratedColumn<double>('scale', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: false, defaultValue: const Constant(1.0));
static const VerificationMeta _rotationMeta = const VerificationMeta('rotation');
@override
late final GeneratedColumn<double> rotation = GeneratedColumn<double>('rotation', aliasedName, false, type: DriftSqlType.double, requiredDuringInsert: false, defaultValue: const Constant(0.0));
static const VerificationMeta _zIndexMeta = const VerificationMeta('zIndex');
@override
late final GeneratedColumn<int> zIndex = GeneratedColumn<int>('z_index', aliasedName, false, type: DriftSqlType.int, requiredDuringInsert: false, defaultValue: const Constant(0));
@override
List<GeneratedColumn> get $columns => [outfitId, clothingItemId, posX, posY, scale, rotation, zIndex];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'outfit_clothing_items';
@override
VerificationContext validateIntegrity(Insertable<OutfitClothingItem> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('outfit_id')) {
context.handle(_outfitIdMeta, outfitId.isAcceptableOrUnknown(data['outfit_id']!, _outfitIdMeta));} else if (isInserting) {
context.missing(_outfitIdMeta);
}
if (data.containsKey('clothing_item_id')) {
context.handle(_clothingItemIdMeta, clothingItemId.isAcceptableOrUnknown(data['clothing_item_id']!, _clothingItemIdMeta));} else if (isInserting) {
context.missing(_clothingItemIdMeta);
}
if (data.containsKey('pos_x')) {
context.handle(_posXMeta, posX.isAcceptableOrUnknown(data['pos_x']!, _posXMeta));}if (data.containsKey('pos_y')) {
context.handle(_posYMeta, posY.isAcceptableOrUnknown(data['pos_y']!, _posYMeta));}if (data.containsKey('scale')) {
context.handle(_scaleMeta, scale.isAcceptableOrUnknown(data['scale']!, _scaleMeta));}if (data.containsKey('rotation')) {
context.handle(_rotationMeta, rotation.isAcceptableOrUnknown(data['rotation']!, _rotationMeta));}if (data.containsKey('z_index')) {
context.handle(_zIndexMeta, zIndex.isAcceptableOrUnknown(data['z_index']!, _zIndexMeta));}return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {outfitId, clothingItemId};
@override OutfitClothingItem map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return OutfitClothingItem(outfitId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}outfit_id'])!, clothingItemId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}clothing_item_id'])!, posX: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}pos_x'])!, posY: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}pos_y'])!, scale: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}scale'])!, rotation: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}rotation'])!, zIndex: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}z_index'])!, );
}
@override
$OutfitClothingItemsTable createAlias(String alias) {
return $OutfitClothingItemsTable(attachedDatabase, alias);}}class OutfitClothingItem extends DataClass implements Insertable<OutfitClothingItem> 
{
final String outfitId;
final String clothingItemId;
final double posX;
final double posY;
final double scale;
final double rotation;
final int zIndex;
const OutfitClothingItem({required this.outfitId, required this.clothingItemId, required this.posX, required this.posY, required this.scale, required this.rotation, required this.zIndex});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['outfit_id'] = Variable<String>(outfitId);
map['clothing_item_id'] = Variable<String>(clothingItemId);
map['pos_x'] = Variable<double>(posX);
map['pos_y'] = Variable<double>(posY);
map['scale'] = Variable<double>(scale);
map['rotation'] = Variable<double>(rotation);
map['z_index'] = Variable<int>(zIndex);
return map; 
}
OutfitClothingItemsCompanion toCompanion(bool nullToAbsent) {
return OutfitClothingItemsCompanion(outfitId: Value(outfitId),clothingItemId: Value(clothingItemId),posX: Value(posX),posY: Value(posY),scale: Value(scale),rotation: Value(rotation),zIndex: Value(zIndex),);
}
factory OutfitClothingItem.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return OutfitClothingItem(outfitId: serializer.fromJson<String>(json['outfitId']),clothingItemId: serializer.fromJson<String>(json['clothingItemId']),posX: serializer.fromJson<double>(json['posX']),posY: serializer.fromJson<double>(json['posY']),scale: serializer.fromJson<double>(json['scale']),rotation: serializer.fromJson<double>(json['rotation']),zIndex: serializer.fromJson<int>(json['zIndex']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'outfitId': serializer.toJson<String>(outfitId),'clothingItemId': serializer.toJson<String>(clothingItemId),'posX': serializer.toJson<double>(posX),'posY': serializer.toJson<double>(posY),'scale': serializer.toJson<double>(scale),'rotation': serializer.toJson<double>(rotation),'zIndex': serializer.toJson<int>(zIndex),};}OutfitClothingItem copyWith({String? outfitId,String? clothingItemId,double? posX,double? posY,double? scale,double? rotation,int? zIndex}) => OutfitClothingItem(outfitId: outfitId ?? this.outfitId,clothingItemId: clothingItemId ?? this.clothingItemId,posX: posX ?? this.posX,posY: posY ?? this.posY,scale: scale ?? this.scale,rotation: rotation ?? this.rotation,zIndex: zIndex ?? this.zIndex,);OutfitClothingItem copyWithCompanion(OutfitClothingItemsCompanion data) {
return OutfitClothingItem(
outfitId: data.outfitId.present ? data.outfitId.value : this.outfitId,clothingItemId: data.clothingItemId.present ? data.clothingItemId.value : this.clothingItemId,posX: data.posX.present ? data.posX.value : this.posX,posY: data.posY.present ? data.posY.value : this.posY,scale: data.scale.present ? data.scale.value : this.scale,rotation: data.rotation.present ? data.rotation.value : this.rotation,zIndex: data.zIndex.present ? data.zIndex.value : this.zIndex,);
}
@override
String toString() {return (StringBuffer('OutfitClothingItem(')..write('outfitId: $outfitId, ')..write('clothingItemId: $clothingItemId, ')..write('posX: $posX, ')..write('posY: $posY, ')..write('scale: $scale, ')..write('rotation: $rotation, ')..write('zIndex: $zIndex')..write(')')).toString();}
@override
 int get hashCode => Object.hash(outfitId, clothingItemId, posX, posY, scale, rotation, zIndex);@override
bool operator ==(Object other) => identical(this, other) || (other is OutfitClothingItem && other.outfitId == this.outfitId && other.clothingItemId == this.clothingItemId && other.posX == this.posX && other.posY == this.posY && other.scale == this.scale && other.rotation == this.rotation && other.zIndex == this.zIndex);
}class OutfitClothingItemsCompanion extends UpdateCompanion<OutfitClothingItem> {
final Value<String> outfitId;
final Value<String> clothingItemId;
final Value<double> posX;
final Value<double> posY;
final Value<double> scale;
final Value<double> rotation;
final Value<int> zIndex;
final Value<int> rowid;
const OutfitClothingItemsCompanion({this.outfitId = const Value.absent(),this.clothingItemId = const Value.absent(),this.posX = const Value.absent(),this.posY = const Value.absent(),this.scale = const Value.absent(),this.rotation = const Value.absent(),this.zIndex = const Value.absent(),this.rowid = const Value.absent(),});
OutfitClothingItemsCompanion.insert({required String outfitId,required String clothingItemId,this.posX = const Value.absent(),this.posY = const Value.absent(),this.scale = const Value.absent(),this.rotation = const Value.absent(),this.zIndex = const Value.absent(),this.rowid = const Value.absent(),}): outfitId = Value(outfitId), clothingItemId = Value(clothingItemId);
static Insertable<OutfitClothingItem> custom({Expression<String>? outfitId, 
Expression<String>? clothingItemId, 
Expression<double>? posX, 
Expression<double>? posY, 
Expression<double>? scale, 
Expression<double>? rotation, 
Expression<int>? zIndex, 
Expression<int>? rowid, 
}) {
return RawValuesInsertable({if (outfitId != null)'outfit_id': outfitId,if (clothingItemId != null)'clothing_item_id': clothingItemId,if (posX != null)'pos_x': posX,if (posY != null)'pos_y': posY,if (scale != null)'scale': scale,if (rotation != null)'rotation': rotation,if (zIndex != null)'z_index': zIndex,if (rowid != null)'rowid': rowid,});
}OutfitClothingItemsCompanion copyWith({Value<String>? outfitId, Value<String>? clothingItemId, Value<double>? posX, Value<double>? posY, Value<double>? scale, Value<double>? rotation, Value<int>? zIndex, Value<int>? rowid}) {
return OutfitClothingItemsCompanion(outfitId: outfitId ?? this.outfitId,clothingItemId: clothingItemId ?? this.clothingItemId,posX: posX ?? this.posX,posY: posY ?? this.posY,scale: scale ?? this.scale,rotation: rotation ?? this.rotation,zIndex: zIndex ?? this.zIndex,rowid: rowid ?? this.rowid,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (outfitId.present) {
map['outfit_id'] = Variable<String>(outfitId.value);}
if (clothingItemId.present) {
map['clothing_item_id'] = Variable<String>(clothingItemId.value);}
if (posX.present) {
map['pos_x'] = Variable<double>(posX.value);}
if (posY.present) {
map['pos_y'] = Variable<double>(posY.value);}
if (scale.present) {
map['scale'] = Variable<double>(scale.value);}
if (rotation.present) {
map['rotation'] = Variable<double>(rotation.value);}
if (zIndex.present) {
map['z_index'] = Variable<int>(zIndex.value);}
if (rowid.present) {
map['rowid'] = Variable<int>(rowid.value);}
return map; 
}
@override
String toString() {return (StringBuffer('OutfitClothingItemsCompanion(')..write('outfitId: $outfitId, ')..write('clothingItemId: $clothingItemId, ')..write('posX: $posX, ')..write('posY: $posY, ')..write('scale: $scale, ')..write('rotation: $rotation, ')..write('zIndex: $zIndex, ')..write('rowid: $rowid')..write(')')).toString();}
}
class $CollectionsTable extends Collections with TableInfo<$CollectionsTable, Collection>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$CollectionsTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _idMeta = const VerificationMeta('id');
@override
late final GeneratedColumn<String> id = GeneratedColumn<String>('id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _nameMeta = const VerificationMeta('name');
@override
late final GeneratedColumn<String> name = GeneratedColumn<String>('name', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
@override
late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>('created_at', aliasedName, false, type: DriftSqlType.dateTime, requiredDuringInsert: false, defaultValue: currentDateAndTime);
@override
List<GeneratedColumn> get $columns => [id, name, createdAt];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'collections';
@override
VerificationContext validateIntegrity(Insertable<Collection> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('id')) {
context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));} else if (isInserting) {
context.missing(_idMeta);
}
if (data.containsKey('name')) {
context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));} else if (isInserting) {
context.missing(_nameMeta);
}
if (data.containsKey('created_at')) {
context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));}return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {id};
@override Collection map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return Collection(id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!, name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!, createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!, );
}
@override
$CollectionsTable createAlias(String alias) {
return $CollectionsTable(attachedDatabase, alias);}}class Collection extends DataClass implements Insertable<Collection> 
{
final String id;
final String name;
final DateTime createdAt;
const Collection({required this.id, required this.name, required this.createdAt});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['id'] = Variable<String>(id);
map['name'] = Variable<String>(name);
map['created_at'] = Variable<DateTime>(createdAt);
return map; 
}
CollectionsCompanion toCompanion(bool nullToAbsent) {
return CollectionsCompanion(id: Value(id),name: Value(name),createdAt: Value(createdAt),);
}
factory Collection.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return Collection(id: serializer.fromJson<String>(json['id']),name: serializer.fromJson<String>(json['name']),createdAt: serializer.fromJson<DateTime>(json['createdAt']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'id': serializer.toJson<String>(id),'name': serializer.toJson<String>(name),'createdAt': serializer.toJson<DateTime>(createdAt),};}Collection copyWith({String? id,String? name,DateTime? createdAt}) => Collection(id: id ?? this.id,name: name ?? this.name,createdAt: createdAt ?? this.createdAt,);Collection copyWithCompanion(CollectionsCompanion data) {
return Collection(
id: data.id.present ? data.id.value : this.id,name: data.name.present ? data.name.value : this.name,createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,);
}
@override
String toString() {return (StringBuffer('Collection(')..write('id: $id, ')..write('name: $name, ')..write('createdAt: $createdAt')..write(')')).toString();}
@override
 int get hashCode => Object.hash(id, name, createdAt);@override
bool operator ==(Object other) => identical(this, other) || (other is Collection && other.id == this.id && other.name == this.name && other.createdAt == this.createdAt);
}class CollectionsCompanion extends UpdateCompanion<Collection> {
final Value<String> id;
final Value<String> name;
final Value<DateTime> createdAt;
final Value<int> rowid;
const CollectionsCompanion({this.id = const Value.absent(),this.name = const Value.absent(),this.createdAt = const Value.absent(),this.rowid = const Value.absent(),});
CollectionsCompanion.insert({required String id,required String name,this.createdAt = const Value.absent(),this.rowid = const Value.absent(),}): id = Value(id), name = Value(name);
static Insertable<Collection> custom({Expression<String>? id, 
Expression<String>? name, 
Expression<DateTime>? createdAt, 
Expression<int>? rowid, 
}) {
return RawValuesInsertable({if (id != null)'id': id,if (name != null)'name': name,if (createdAt != null)'created_at': createdAt,if (rowid != null)'rowid': rowid,});
}CollectionsCompanion copyWith({Value<String>? id, Value<String>? name, Value<DateTime>? createdAt, Value<int>? rowid}) {
return CollectionsCompanion(id: id ?? this.id,name: name ?? this.name,createdAt: createdAt ?? this.createdAt,rowid: rowid ?? this.rowid,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (id.present) {
map['id'] = Variable<String>(id.value);}
if (name.present) {
map['name'] = Variable<String>(name.value);}
if (createdAt.present) {
map['created_at'] = Variable<DateTime>(createdAt.value);}
if (rowid.present) {
map['rowid'] = Variable<int>(rowid.value);}
return map; 
}
@override
String toString() {return (StringBuffer('CollectionsCompanion(')..write('id: $id, ')..write('name: $name, ')..write('createdAt: $createdAt, ')..write('rowid: $rowid')..write(')')).toString();}
}
class $CollectionOutfitsTable extends CollectionOutfits with TableInfo<$CollectionOutfitsTable, CollectionOutfit>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$CollectionOutfitsTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _collectionIdMeta = const VerificationMeta('collectionId');
@override
late final GeneratedColumn<String> collectionId = GeneratedColumn<String>('collection_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _outfitIdMeta = const VerificationMeta('outfitId');
@override
late final GeneratedColumn<String> outfitId = GeneratedColumn<String>('outfit_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
@override
List<GeneratedColumn> get $columns => [collectionId, outfitId];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'collection_outfits';
@override
VerificationContext validateIntegrity(Insertable<CollectionOutfit> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('collection_id')) {
context.handle(_collectionIdMeta, collectionId.isAcceptableOrUnknown(data['collection_id']!, _collectionIdMeta));} else if (isInserting) {
context.missing(_collectionIdMeta);
}
if (data.containsKey('outfit_id')) {
context.handle(_outfitIdMeta, outfitId.isAcceptableOrUnknown(data['outfit_id']!, _outfitIdMeta));} else if (isInserting) {
context.missing(_outfitIdMeta);
}
return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {collectionId, outfitId};
@override CollectionOutfit map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return CollectionOutfit(collectionId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}collection_id'])!, outfitId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}outfit_id'])!, );
}
@override
$CollectionOutfitsTable createAlias(String alias) {
return $CollectionOutfitsTable(attachedDatabase, alias);}}class CollectionOutfit extends DataClass implements Insertable<CollectionOutfit> 
{
final String collectionId;
final String outfitId;
const CollectionOutfit({required this.collectionId, required this.outfitId});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['collection_id'] = Variable<String>(collectionId);
map['outfit_id'] = Variable<String>(outfitId);
return map; 
}
CollectionOutfitsCompanion toCompanion(bool nullToAbsent) {
return CollectionOutfitsCompanion(collectionId: Value(collectionId),outfitId: Value(outfitId),);
}
factory CollectionOutfit.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return CollectionOutfit(collectionId: serializer.fromJson<String>(json['collectionId']),outfitId: serializer.fromJson<String>(json['outfitId']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'collectionId': serializer.toJson<String>(collectionId),'outfitId': serializer.toJson<String>(outfitId),};}CollectionOutfit copyWith({String? collectionId,String? outfitId}) => CollectionOutfit(collectionId: collectionId ?? this.collectionId,outfitId: outfitId ?? this.outfitId,);CollectionOutfit copyWithCompanion(CollectionOutfitsCompanion data) {
return CollectionOutfit(
collectionId: data.collectionId.present ? data.collectionId.value : this.collectionId,outfitId: data.outfitId.present ? data.outfitId.value : this.outfitId,);
}
@override
String toString() {return (StringBuffer('CollectionOutfit(')..write('collectionId: $collectionId, ')..write('outfitId: $outfitId')..write(')')).toString();}
@override
 int get hashCode => Object.hash(collectionId, outfitId);@override
bool operator ==(Object other) => identical(this, other) || (other is CollectionOutfit && other.collectionId == this.collectionId && other.outfitId == this.outfitId);
}class CollectionOutfitsCompanion extends UpdateCompanion<CollectionOutfit> {
final Value<String> collectionId;
final Value<String> outfitId;
final Value<int> rowid;
const CollectionOutfitsCompanion({this.collectionId = const Value.absent(),this.outfitId = const Value.absent(),this.rowid = const Value.absent(),});
CollectionOutfitsCompanion.insert({required String collectionId,required String outfitId,this.rowid = const Value.absent(),}): collectionId = Value(collectionId), outfitId = Value(outfitId);
static Insertable<CollectionOutfit> custom({Expression<String>? collectionId, 
Expression<String>? outfitId, 
Expression<int>? rowid, 
}) {
return RawValuesInsertable({if (collectionId != null)'collection_id': collectionId,if (outfitId != null)'outfit_id': outfitId,if (rowid != null)'rowid': rowid,});
}CollectionOutfitsCompanion copyWith({Value<String>? collectionId, Value<String>? outfitId, Value<int>? rowid}) {
return CollectionOutfitsCompanion(collectionId: collectionId ?? this.collectionId,outfitId: outfitId ?? this.outfitId,rowid: rowid ?? this.rowid,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (collectionId.present) {
map['collection_id'] = Variable<String>(collectionId.value);}
if (outfitId.present) {
map['outfit_id'] = Variable<String>(outfitId.value);}
if (rowid.present) {
map['rowid'] = Variable<int>(rowid.value);}
return map; 
}
@override
String toString() {return (StringBuffer('CollectionOutfitsCompanion(')..write('collectionId: $collectionId, ')..write('outfitId: $outfitId, ')..write('rowid: $rowid')..write(')')).toString();}
}
class $CollectionClothingItemsTable extends CollectionClothingItems with TableInfo<$CollectionClothingItemsTable, CollectionClothingItem>{
@override final GeneratedDatabase attachedDatabase;
final String? _alias;
$CollectionClothingItemsTable(this.attachedDatabase, [this._alias]);
static const VerificationMeta _collectionIdMeta = const VerificationMeta('collectionId');
@override
late final GeneratedColumn<String> collectionId = GeneratedColumn<String>('collection_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
static const VerificationMeta _clothingItemIdMeta = const VerificationMeta('clothingItemId');
@override
late final GeneratedColumn<String> clothingItemId = GeneratedColumn<String>('clothing_item_id', aliasedName, false, type: DriftSqlType.string, requiredDuringInsert: true);
@override
List<GeneratedColumn> get $columns => [collectionId, clothingItemId];
@override
String get aliasedName => _alias ?? actualTableName;
@override
 String get actualTableName => $name;
static const String $name = 'collection_clothing_items';
@override
VerificationContext validateIntegrity(Insertable<CollectionClothingItem> instance, {bool isInserting = false}) {
final context = VerificationContext();
final data = instance.toColumns(true);
if (data.containsKey('collection_id')) {
context.handle(_collectionIdMeta, collectionId.isAcceptableOrUnknown(data['collection_id']!, _collectionIdMeta));} else if (isInserting) {
context.missing(_collectionIdMeta);
}
if (data.containsKey('clothing_item_id')) {
context.handle(_clothingItemIdMeta, clothingItemId.isAcceptableOrUnknown(data['clothing_item_id']!, _clothingItemIdMeta));} else if (isInserting) {
context.missing(_clothingItemIdMeta);
}
return context;
}
@override
Set<GeneratedColumn> get $primaryKey => {collectionId, clothingItemId};
@override CollectionClothingItem map(Map<String, dynamic> data, {String? tablePrefix})  {
final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';return CollectionClothingItem(collectionId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}collection_id'])!, clothingItemId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}clothing_item_id'])!, );
}
@override
$CollectionClothingItemsTable createAlias(String alias) {
return $CollectionClothingItemsTable(attachedDatabase, alias);}}class CollectionClothingItem extends DataClass implements Insertable<CollectionClothingItem> 
{
final String collectionId;
final String clothingItemId;
const CollectionClothingItem({required this.collectionId, required this.clothingItemId});@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};map['collection_id'] = Variable<String>(collectionId);
map['clothing_item_id'] = Variable<String>(clothingItemId);
return map; 
}
CollectionClothingItemsCompanion toCompanion(bool nullToAbsent) {
return CollectionClothingItemsCompanion(collectionId: Value(collectionId),clothingItemId: Value(clothingItemId),);
}
factory CollectionClothingItem.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return CollectionClothingItem(collectionId: serializer.fromJson<String>(json['collectionId']),clothingItemId: serializer.fromJson<String>(json['clothingItemId']),);}
@override Map<String, dynamic> toJson({ValueSerializer? serializer}) {
serializer ??= driftRuntimeOptions.defaultSerializer;
return <String, dynamic>{
'collectionId': serializer.toJson<String>(collectionId),'clothingItemId': serializer.toJson<String>(clothingItemId),};}CollectionClothingItem copyWith({String? collectionId,String? clothingItemId}) => CollectionClothingItem(collectionId: collectionId ?? this.collectionId,clothingItemId: clothingItemId ?? this.clothingItemId,);CollectionClothingItem copyWithCompanion(CollectionClothingItemsCompanion data) {
return CollectionClothingItem(
collectionId: data.collectionId.present ? data.collectionId.value : this.collectionId,clothingItemId: data.clothingItemId.present ? data.clothingItemId.value : this.clothingItemId,);
}
@override
String toString() {return (StringBuffer('CollectionClothingItem(')..write('collectionId: $collectionId, ')..write('clothingItemId: $clothingItemId')..write(')')).toString();}
@override
 int get hashCode => Object.hash(collectionId, clothingItemId);@override
bool operator ==(Object other) => identical(this, other) || (other is CollectionClothingItem && other.collectionId == this.collectionId && other.clothingItemId == this.clothingItemId);
}class CollectionClothingItemsCompanion extends UpdateCompanion<CollectionClothingItem> {
final Value<String> collectionId;
final Value<String> clothingItemId;
final Value<int> rowid;
const CollectionClothingItemsCompanion({this.collectionId = const Value.absent(),this.clothingItemId = const Value.absent(),this.rowid = const Value.absent(),});
CollectionClothingItemsCompanion.insert({required String collectionId,required String clothingItemId,this.rowid = const Value.absent(),}): collectionId = Value(collectionId), clothingItemId = Value(clothingItemId);
static Insertable<CollectionClothingItem> custom({Expression<String>? collectionId, 
Expression<String>? clothingItemId, 
Expression<int>? rowid, 
}) {
return RawValuesInsertable({if (collectionId != null)'collection_id': collectionId,if (clothingItemId != null)'clothing_item_id': clothingItemId,if (rowid != null)'rowid': rowid,});
}CollectionClothingItemsCompanion copyWith({Value<String>? collectionId, Value<String>? clothingItemId, Value<int>? rowid}) {
return CollectionClothingItemsCompanion(collectionId: collectionId ?? this.collectionId,clothingItemId: clothingItemId ?? this.clothingItemId,rowid: rowid ?? this.rowid,);
}
@override
Map<String, Expression> toColumns(bool nullToAbsent) {
final map = <String, Expression> {};if (collectionId.present) {
map['collection_id'] = Variable<String>(collectionId.value);}
if (clothingItemId.present) {
map['clothing_item_id'] = Variable<String>(clothingItemId.value);}
if (rowid.present) {
map['rowid'] = Variable<int>(rowid.value);}
return map; 
}
@override
String toString() {return (StringBuffer('CollectionClothingItemsCompanion(')..write('collectionId: $collectionId, ')..write('clothingItemId: $clothingItemId, ')..write('rowid: $rowid')..write(')')).toString();}
}
abstract class _$AppDatabase extends GeneratedDatabase{
_$AppDatabase(QueryExecutor e): super(e);
$AppDatabaseManager get managers => $AppDatabaseManager(this);
late final $ClothingItemsTable clothingItems = $ClothingItemsTable(this);
late final $OutfitsTable outfits = $OutfitsTable(this);
late final $OutfitClothingItemsTable outfitClothingItems = $OutfitClothingItemsTable(this);
late final $CollectionsTable collections = $CollectionsTable(this);
late final $CollectionOutfitsTable collectionOutfits = $CollectionOutfitsTable(this);
late final $CollectionClothingItemsTable collectionClothingItems = $CollectionClothingItemsTable(this);
@override
Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
@override
List<DatabaseSchemaEntity> get allSchemaEntities => [clothingItems, outfits, outfitClothingItems, collections, collectionOutfits, collectionClothingItems];
}
typedef $$ClothingItemsTableCreateCompanionBuilder = ClothingItemsCompanion Function({required String id,required String imagePath,required String category,Value<String?> subcategory,Value<String?> color,Value<List<String>> seasons,Value<List<String>> styleTags,Value<List<String>> weatherTags,Value<int> sortOrder,Value<DateTime> createdAt,Value<int> rowid,});
typedef $$ClothingItemsTableUpdateCompanionBuilder = ClothingItemsCompanion Function({Value<String> id,Value<String> imagePath,Value<String> category,Value<String?> subcategory,Value<String?> color,Value<List<String>> seasons,Value<List<String>> styleTags,Value<List<String>> weatherTags,Value<int> sortOrder,Value<DateTime> createdAt,Value<int> rowid,});
class $$ClothingItemsTableFilterComposer extends Composer<
        _$AppDatabase,
        $ClothingItemsTable> {
        $$ClothingItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get imagePath => $composableBuilder(
      column: $table.imagePath,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get category => $composableBuilder(
      column: $table.category,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get subcategory => $composableBuilder(
      column: $table.subcategory,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get color => $composableBuilder(
      column: $table.color,
      builder: (column) => 
      ColumnFilters(column));
      
          ColumnWithTypeConverterFilters<List<String>,List<String>,String> get seasons => $composableBuilder(
      column: $table.seasons,
      builder: (column) => 
      ColumnWithTypeConverterFilters(column));
      
          ColumnWithTypeConverterFilters<List<String>,List<String>,String> get styleTags => $composableBuilder(
      column: $table.styleTags,
      builder: (column) => 
      ColumnWithTypeConverterFilters(column));
      
          ColumnWithTypeConverterFilters<List<String>,List<String>,String> get weatherTags => $composableBuilder(
      column: $table.weatherTags,
      builder: (column) => 
      ColumnWithTypeConverterFilters(column));
      
ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$ClothingItemsTableOrderingComposer extends Composer<
        _$AppDatabase,
        $ClothingItemsTable> {
        $$ClothingItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get imagePath => $composableBuilder(
      column: $table.imagePath,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get subcategory => $composableBuilder(
      column: $table.subcategory,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get color => $composableBuilder(
      column: $table.color,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get seasons => $composableBuilder(
      column: $table.seasons,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get styleTags => $composableBuilder(
      column: $table.styleTags,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get weatherTags => $composableBuilder(
      column: $table.weatherTags,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$ClothingItemsTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $ClothingItemsTable> {
        $$ClothingItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<String> get imagePath => $composableBuilder(
      column: $table.imagePath,
      builder: (column) => column);
      
GeneratedColumn<String> get category => $composableBuilder(
      column: $table.category,
      builder: (column) => column);
      
GeneratedColumn<String> get subcategory => $composableBuilder(
      column: $table.subcategory,
      builder: (column) => column);
      
GeneratedColumn<String> get color => $composableBuilder(
      column: $table.color,
      builder: (column) => column);
      
          GeneratedColumnWithTypeConverter<List<String>,String> get seasons => $composableBuilder(
      column: $table.seasons,
      builder: (column) => column);
      
          GeneratedColumnWithTypeConverter<List<String>,String> get styleTags => $composableBuilder(
      column: $table.styleTags,
      builder: (column) => column);
      
          GeneratedColumnWithTypeConverter<List<String>,String> get weatherTags => $composableBuilder(
      column: $table.weatherTags,
      builder: (column) => column);
      
GeneratedColumn<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
        }
      class $$ClothingItemsTableTableManager extends RootTableManager    <_$AppDatabase,
    $ClothingItemsTable,
    ClothingItem,
    $$ClothingItemsTableFilterComposer,
    $$ClothingItemsTableOrderingComposer,
    $$ClothingItemsTableAnnotationComposer,
    $$ClothingItemsTableCreateCompanionBuilder,
    $$ClothingItemsTableUpdateCompanionBuilder,
    (ClothingItem,BaseReferences<_$AppDatabase,$ClothingItemsTable,ClothingItem>),
    ClothingItem,
    PrefetchHooks Function()
    > {
    $$ClothingItemsTableTableManager(_$AppDatabase db, $ClothingItemsTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$ClothingItemsTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$ClothingItemsTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$ClothingItemsTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<String> id = const Value.absent(),Value<String> imagePath = const Value.absent(),Value<String> category = const Value.absent(),Value<String?> subcategory = const Value.absent(),Value<String?> color = const Value.absent(),Value<List<String>> seasons = const Value.absent(),Value<List<String>> styleTags = const Value.absent(),Value<List<String>> weatherTags = const Value.absent(),Value<int> sortOrder = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<int> rowid = const Value.absent(),})=> ClothingItemsCompanion(id: id,imagePath: imagePath,category: category,subcategory: subcategory,color: color,seasons: seasons,styleTags: styleTags,weatherTags: weatherTags,sortOrder: sortOrder,createdAt: createdAt,rowid: rowid,),
        createCompanionCallback: ({required String id,required String imagePath,required String category,Value<String?> subcategory = const Value.absent(),Value<String?> color = const Value.absent(),Value<List<String>> seasons = const Value.absent(),Value<List<String>> styleTags = const Value.absent(),Value<List<String>> weatherTags = const Value.absent(),Value<int> sortOrder = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<int> rowid = const Value.absent(),})=> ClothingItemsCompanion.insert(id: id,imagePath: imagePath,category: category,subcategory: subcategory,color: color,seasons: seasons,styleTags: styleTags,weatherTags: weatherTags,sortOrder: sortOrder,createdAt: createdAt,rowid: rowid,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$ClothingItemsTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $ClothingItemsTable,
    ClothingItem,
    $$ClothingItemsTableFilterComposer,
    $$ClothingItemsTableOrderingComposer,
    $$ClothingItemsTableAnnotationComposer,
    $$ClothingItemsTableCreateCompanionBuilder,
    $$ClothingItemsTableUpdateCompanionBuilder,
    (ClothingItem,BaseReferences<_$AppDatabase,$ClothingItemsTable,ClothingItem>),
    ClothingItem,
    PrefetchHooks Function()
    >;typedef $$OutfitsTableCreateCompanionBuilder = OutfitsCompanion Function({required String id,required String name,Value<List<String>> styleTags,Value<List<String>> weatherTags,Value<int> sortOrder,Value<DateTime> createdAt,Value<int> rowid,});
typedef $$OutfitsTableUpdateCompanionBuilder = OutfitsCompanion Function({Value<String> id,Value<String> name,Value<List<String>> styleTags,Value<List<String>> weatherTags,Value<int> sortOrder,Value<DateTime> createdAt,Value<int> rowid,});
class $$OutfitsTableFilterComposer extends Composer<
        _$AppDatabase,
        $OutfitsTable> {
        $$OutfitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get name => $composableBuilder(
      column: $table.name,
      builder: (column) => 
      ColumnFilters(column));
      
          ColumnWithTypeConverterFilters<List<String>,List<String>,String> get styleTags => $composableBuilder(
      column: $table.styleTags,
      builder: (column) => 
      ColumnWithTypeConverterFilters(column));
      
          ColumnWithTypeConverterFilters<List<String>,List<String>,String> get weatherTags => $composableBuilder(
      column: $table.weatherTags,
      builder: (column) => 
      ColumnWithTypeConverterFilters(column));
      
ColumnFilters<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$OutfitsTableOrderingComposer extends Composer<
        _$AppDatabase,
        $OutfitsTable> {
        $$OutfitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get styleTags => $composableBuilder(
      column: $table.styleTags,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get weatherTags => $composableBuilder(
      column: $table.weatherTags,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$OutfitsTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $OutfitsTable> {
        $$OutfitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<String> get name => $composableBuilder(
      column: $table.name,
      builder: (column) => column);
      
          GeneratedColumnWithTypeConverter<List<String>,String> get styleTags => $composableBuilder(
      column: $table.styleTags,
      builder: (column) => column);
      
          GeneratedColumnWithTypeConverter<List<String>,String> get weatherTags => $composableBuilder(
      column: $table.weatherTags,
      builder: (column) => column);
      
GeneratedColumn<int> get sortOrder => $composableBuilder(
      column: $table.sortOrder,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
        }
      class $$OutfitsTableTableManager extends RootTableManager    <_$AppDatabase,
    $OutfitsTable,
    Outfit,
    $$OutfitsTableFilterComposer,
    $$OutfitsTableOrderingComposer,
    $$OutfitsTableAnnotationComposer,
    $$OutfitsTableCreateCompanionBuilder,
    $$OutfitsTableUpdateCompanionBuilder,
    (Outfit,BaseReferences<_$AppDatabase,$OutfitsTable,Outfit>),
    Outfit,
    PrefetchHooks Function()
    > {
    $$OutfitsTableTableManager(_$AppDatabase db, $OutfitsTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$OutfitsTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$OutfitsTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$OutfitsTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<String> id = const Value.absent(),Value<String> name = const Value.absent(),Value<List<String>> styleTags = const Value.absent(),Value<List<String>> weatherTags = const Value.absent(),Value<int> sortOrder = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<int> rowid = const Value.absent(),})=> OutfitsCompanion(id: id,name: name,styleTags: styleTags,weatherTags: weatherTags,sortOrder: sortOrder,createdAt: createdAt,rowid: rowid,),
        createCompanionCallback: ({required String id,required String name,Value<List<String>> styleTags = const Value.absent(),Value<List<String>> weatherTags = const Value.absent(),Value<int> sortOrder = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<int> rowid = const Value.absent(),})=> OutfitsCompanion.insert(id: id,name: name,styleTags: styleTags,weatherTags: weatherTags,sortOrder: sortOrder,createdAt: createdAt,rowid: rowid,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$OutfitsTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $OutfitsTable,
    Outfit,
    $$OutfitsTableFilterComposer,
    $$OutfitsTableOrderingComposer,
    $$OutfitsTableAnnotationComposer,
    $$OutfitsTableCreateCompanionBuilder,
    $$OutfitsTableUpdateCompanionBuilder,
    (Outfit,BaseReferences<_$AppDatabase,$OutfitsTable,Outfit>),
    Outfit,
    PrefetchHooks Function()
    >;typedef $$OutfitClothingItemsTableCreateCompanionBuilder = OutfitClothingItemsCompanion Function({required String outfitId,required String clothingItemId,Value<double> posX,Value<double> posY,Value<double> scale,Value<double> rotation,Value<int> zIndex,Value<int> rowid,});
typedef $$OutfitClothingItemsTableUpdateCompanionBuilder = OutfitClothingItemsCompanion Function({Value<String> outfitId,Value<String> clothingItemId,Value<double> posX,Value<double> posY,Value<double> scale,Value<double> rotation,Value<int> zIndex,Value<int> rowid,});
class $$OutfitClothingItemsTableFilterComposer extends Composer<
        _$AppDatabase,
        $OutfitClothingItemsTable> {
        $$OutfitClothingItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<String> get outfitId => $composableBuilder(
      column: $table.outfitId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get clothingItemId => $composableBuilder(
      column: $table.clothingItemId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<double> get posX => $composableBuilder(
      column: $table.posX,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<double> get posY => $composableBuilder(
      column: $table.posY,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<double> get scale => $composableBuilder(
      column: $table.scale,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<double> get rotation => $composableBuilder(
      column: $table.rotation,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<int> get zIndex => $composableBuilder(
      column: $table.zIndex,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$OutfitClothingItemsTableOrderingComposer extends Composer<
        _$AppDatabase,
        $OutfitClothingItemsTable> {
        $$OutfitClothingItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<String> get outfitId => $composableBuilder(
      column: $table.outfitId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get clothingItemId => $composableBuilder(
      column: $table.clothingItemId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<double> get posX => $composableBuilder(
      column: $table.posX,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<double> get posY => $composableBuilder(
      column: $table.posY,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<double> get scale => $composableBuilder(
      column: $table.scale,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<double> get rotation => $composableBuilder(
      column: $table.rotation,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<int> get zIndex => $composableBuilder(
      column: $table.zIndex,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$OutfitClothingItemsTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $OutfitClothingItemsTable> {
        $$OutfitClothingItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<String> get outfitId => $composableBuilder(
      column: $table.outfitId,
      builder: (column) => column);
      
GeneratedColumn<String> get clothingItemId => $composableBuilder(
      column: $table.clothingItemId,
      builder: (column) => column);
      
GeneratedColumn<double> get posX => $composableBuilder(
      column: $table.posX,
      builder: (column) => column);
      
GeneratedColumn<double> get posY => $composableBuilder(
      column: $table.posY,
      builder: (column) => column);
      
GeneratedColumn<double> get scale => $composableBuilder(
      column: $table.scale,
      builder: (column) => column);
      
GeneratedColumn<double> get rotation => $composableBuilder(
      column: $table.rotation,
      builder: (column) => column);
      
GeneratedColumn<int> get zIndex => $composableBuilder(
      column: $table.zIndex,
      builder: (column) => column);
      
        }
      class $$OutfitClothingItemsTableTableManager extends RootTableManager    <_$AppDatabase,
    $OutfitClothingItemsTable,
    OutfitClothingItem,
    $$OutfitClothingItemsTableFilterComposer,
    $$OutfitClothingItemsTableOrderingComposer,
    $$OutfitClothingItemsTableAnnotationComposer,
    $$OutfitClothingItemsTableCreateCompanionBuilder,
    $$OutfitClothingItemsTableUpdateCompanionBuilder,
    (OutfitClothingItem,BaseReferences<_$AppDatabase,$OutfitClothingItemsTable,OutfitClothingItem>),
    OutfitClothingItem,
    PrefetchHooks Function()
    > {
    $$OutfitClothingItemsTableTableManager(_$AppDatabase db, $OutfitClothingItemsTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$OutfitClothingItemsTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$OutfitClothingItemsTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$OutfitClothingItemsTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<String> outfitId = const Value.absent(),Value<String> clothingItemId = const Value.absent(),Value<double> posX = const Value.absent(),Value<double> posY = const Value.absent(),Value<double> scale = const Value.absent(),Value<double> rotation = const Value.absent(),Value<int> zIndex = const Value.absent(),Value<int> rowid = const Value.absent(),})=> OutfitClothingItemsCompanion(outfitId: outfitId,clothingItemId: clothingItemId,posX: posX,posY: posY,scale: scale,rotation: rotation,zIndex: zIndex,rowid: rowid,),
        createCompanionCallback: ({required String outfitId,required String clothingItemId,Value<double> posX = const Value.absent(),Value<double> posY = const Value.absent(),Value<double> scale = const Value.absent(),Value<double> rotation = const Value.absent(),Value<int> zIndex = const Value.absent(),Value<int> rowid = const Value.absent(),})=> OutfitClothingItemsCompanion.insert(outfitId: outfitId,clothingItemId: clothingItemId,posX: posX,posY: posY,scale: scale,rotation: rotation,zIndex: zIndex,rowid: rowid,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$OutfitClothingItemsTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $OutfitClothingItemsTable,
    OutfitClothingItem,
    $$OutfitClothingItemsTableFilterComposer,
    $$OutfitClothingItemsTableOrderingComposer,
    $$OutfitClothingItemsTableAnnotationComposer,
    $$OutfitClothingItemsTableCreateCompanionBuilder,
    $$OutfitClothingItemsTableUpdateCompanionBuilder,
    (OutfitClothingItem,BaseReferences<_$AppDatabase,$OutfitClothingItemsTable,OutfitClothingItem>),
    OutfitClothingItem,
    PrefetchHooks Function()
    >;typedef $$CollectionsTableCreateCompanionBuilder = CollectionsCompanion Function({required String id,required String name,Value<DateTime> createdAt,Value<int> rowid,});
typedef $$CollectionsTableUpdateCompanionBuilder = CollectionsCompanion Function({Value<String> id,Value<String> name,Value<DateTime> createdAt,Value<int> rowid,});
class $$CollectionsTableFilterComposer extends Composer<
        _$AppDatabase,
        $CollectionsTable> {
        $$CollectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get name => $composableBuilder(
      column: $table.name,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$CollectionsTableOrderingComposer extends Composer<
        _$AppDatabase,
        $CollectionsTable> {
        $$CollectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$CollectionsTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $CollectionsTable> {
        $$CollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<String> get id => $composableBuilder(
      column: $table.id,
      builder: (column) => column);
      
GeneratedColumn<String> get name => $composableBuilder(
      column: $table.name,
      builder: (column) => column);
      
GeneratedColumn<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt,
      builder: (column) => column);
      
        }
      class $$CollectionsTableTableManager extends RootTableManager    <_$AppDatabase,
    $CollectionsTable,
    Collection,
    $$CollectionsTableFilterComposer,
    $$CollectionsTableOrderingComposer,
    $$CollectionsTableAnnotationComposer,
    $$CollectionsTableCreateCompanionBuilder,
    $$CollectionsTableUpdateCompanionBuilder,
    (Collection,BaseReferences<_$AppDatabase,$CollectionsTable,Collection>),
    Collection,
    PrefetchHooks Function()
    > {
    $$CollectionsTableTableManager(_$AppDatabase db, $CollectionsTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$CollectionsTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$CollectionsTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$CollectionsTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<String> id = const Value.absent(),Value<String> name = const Value.absent(),Value<DateTime> createdAt = const Value.absent(),Value<int> rowid = const Value.absent(),})=> CollectionsCompanion(id: id,name: name,createdAt: createdAt,rowid: rowid,),
        createCompanionCallback: ({required String id,required String name,Value<DateTime> createdAt = const Value.absent(),Value<int> rowid = const Value.absent(),})=> CollectionsCompanion.insert(id: id,name: name,createdAt: createdAt,rowid: rowid,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$CollectionsTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $CollectionsTable,
    Collection,
    $$CollectionsTableFilterComposer,
    $$CollectionsTableOrderingComposer,
    $$CollectionsTableAnnotationComposer,
    $$CollectionsTableCreateCompanionBuilder,
    $$CollectionsTableUpdateCompanionBuilder,
    (Collection,BaseReferences<_$AppDatabase,$CollectionsTable,Collection>),
    Collection,
    PrefetchHooks Function()
    >;typedef $$CollectionOutfitsTableCreateCompanionBuilder = CollectionOutfitsCompanion Function({required String collectionId,required String outfitId,Value<int> rowid,});
typedef $$CollectionOutfitsTableUpdateCompanionBuilder = CollectionOutfitsCompanion Function({Value<String> collectionId,Value<String> outfitId,Value<int> rowid,});
class $$CollectionOutfitsTableFilterComposer extends Composer<
        _$AppDatabase,
        $CollectionOutfitsTable> {
        $$CollectionOutfitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<String> get collectionId => $composableBuilder(
      column: $table.collectionId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get outfitId => $composableBuilder(
      column: $table.outfitId,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$CollectionOutfitsTableOrderingComposer extends Composer<
        _$AppDatabase,
        $CollectionOutfitsTable> {
        $$CollectionOutfitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<String> get collectionId => $composableBuilder(
      column: $table.collectionId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get outfitId => $composableBuilder(
      column: $table.outfitId,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$CollectionOutfitsTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $CollectionOutfitsTable> {
        $$CollectionOutfitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<String> get collectionId => $composableBuilder(
      column: $table.collectionId,
      builder: (column) => column);
      
GeneratedColumn<String> get outfitId => $composableBuilder(
      column: $table.outfitId,
      builder: (column) => column);
      
        }
      class $$CollectionOutfitsTableTableManager extends RootTableManager    <_$AppDatabase,
    $CollectionOutfitsTable,
    CollectionOutfit,
    $$CollectionOutfitsTableFilterComposer,
    $$CollectionOutfitsTableOrderingComposer,
    $$CollectionOutfitsTableAnnotationComposer,
    $$CollectionOutfitsTableCreateCompanionBuilder,
    $$CollectionOutfitsTableUpdateCompanionBuilder,
    (CollectionOutfit,BaseReferences<_$AppDatabase,$CollectionOutfitsTable,CollectionOutfit>),
    CollectionOutfit,
    PrefetchHooks Function()
    > {
    $$CollectionOutfitsTableTableManager(_$AppDatabase db, $CollectionOutfitsTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$CollectionOutfitsTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$CollectionOutfitsTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$CollectionOutfitsTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<String> collectionId = const Value.absent(),Value<String> outfitId = const Value.absent(),Value<int> rowid = const Value.absent(),})=> CollectionOutfitsCompanion(collectionId: collectionId,outfitId: outfitId,rowid: rowid,),
        createCompanionCallback: ({required String collectionId,required String outfitId,Value<int> rowid = const Value.absent(),})=> CollectionOutfitsCompanion.insert(collectionId: collectionId,outfitId: outfitId,rowid: rowid,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$CollectionOutfitsTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $CollectionOutfitsTable,
    CollectionOutfit,
    $$CollectionOutfitsTableFilterComposer,
    $$CollectionOutfitsTableOrderingComposer,
    $$CollectionOutfitsTableAnnotationComposer,
    $$CollectionOutfitsTableCreateCompanionBuilder,
    $$CollectionOutfitsTableUpdateCompanionBuilder,
    (CollectionOutfit,BaseReferences<_$AppDatabase,$CollectionOutfitsTable,CollectionOutfit>),
    CollectionOutfit,
    PrefetchHooks Function()
    >;typedef $$CollectionClothingItemsTableCreateCompanionBuilder = CollectionClothingItemsCompanion Function({required String collectionId,required String clothingItemId,Value<int> rowid,});
typedef $$CollectionClothingItemsTableUpdateCompanionBuilder = CollectionClothingItemsCompanion Function({Value<String> collectionId,Value<String> clothingItemId,Value<int> rowid,});
class $$CollectionClothingItemsTableFilterComposer extends Composer<
        _$AppDatabase,
        $CollectionClothingItemsTable> {
        $$CollectionClothingItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnFilters<String> get collectionId => $composableBuilder(
      column: $table.collectionId,
      builder: (column) => 
      ColumnFilters(column));
      
ColumnFilters<String> get clothingItemId => $composableBuilder(
      column: $table.clothingItemId,
      builder: (column) => 
      ColumnFilters(column));
      
        }
      class $$CollectionClothingItemsTableOrderingComposer extends Composer<
        _$AppDatabase,
        $CollectionClothingItemsTable> {
        $$CollectionClothingItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          ColumnOrderings<String> get collectionId => $composableBuilder(
      column: $table.collectionId,
      builder: (column) => 
      ColumnOrderings(column));
      
ColumnOrderings<String> get clothingItemId => $composableBuilder(
      column: $table.clothingItemId,
      builder: (column) => 
      ColumnOrderings(column));
      
        }
      class $$CollectionClothingItemsTableAnnotationComposer extends Composer<
        _$AppDatabase,
        $CollectionClothingItemsTable> {
        $$CollectionClothingItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
          GeneratedColumn<String> get collectionId => $composableBuilder(
      column: $table.collectionId,
      builder: (column) => column);
      
GeneratedColumn<String> get clothingItemId => $composableBuilder(
      column: $table.clothingItemId,
      builder: (column) => column);
      
        }
      class $$CollectionClothingItemsTableTableManager extends RootTableManager    <_$AppDatabase,
    $CollectionClothingItemsTable,
    CollectionClothingItem,
    $$CollectionClothingItemsTableFilterComposer,
    $$CollectionClothingItemsTableOrderingComposer,
    $$CollectionClothingItemsTableAnnotationComposer,
    $$CollectionClothingItemsTableCreateCompanionBuilder,
    $$CollectionClothingItemsTableUpdateCompanionBuilder,
    (CollectionClothingItem,BaseReferences<_$AppDatabase,$CollectionClothingItemsTable,CollectionClothingItem>),
    CollectionClothingItem,
    PrefetchHooks Function()
    > {
    $$CollectionClothingItemsTableTableManager(_$AppDatabase db, $CollectionClothingItemsTable table) : super(
      TableManagerState(
        db: db,
        table: table,
        createFilteringComposer: () => $$CollectionClothingItemsTableFilterComposer($db: db,$table:table),
        createOrderingComposer: () => $$CollectionClothingItemsTableOrderingComposer($db: db,$table:table),
        createComputedFieldComposer: () => $$CollectionClothingItemsTableAnnotationComposer($db: db,$table:table),
        updateCompanionCallback: ({Value<String> collectionId = const Value.absent(),Value<String> clothingItemId = const Value.absent(),Value<int> rowid = const Value.absent(),})=> CollectionClothingItemsCompanion(collectionId: collectionId,clothingItemId: clothingItemId,rowid: rowid,),
        createCompanionCallback: ({required String collectionId,required String clothingItemId,Value<int> rowid = const Value.absent(),})=> CollectionClothingItemsCompanion.insert(collectionId: collectionId,clothingItemId: clothingItemId,rowid: rowid,),
        withReferenceMapper: (p0) => p0
              .map(
                  (e) =>
                     (e.readTable(table), BaseReferences(db, table, e))
                  )
              .toList(),
        prefetchHooksCallback: null,
        ));
        }
    typedef $$CollectionClothingItemsTableProcessedTableManager = ProcessedTableManager    <_$AppDatabase,
    $CollectionClothingItemsTable,
    CollectionClothingItem,
    $$CollectionClothingItemsTableFilterComposer,
    $$CollectionClothingItemsTableOrderingComposer,
    $$CollectionClothingItemsTableAnnotationComposer,
    $$CollectionClothingItemsTableCreateCompanionBuilder,
    $$CollectionClothingItemsTableUpdateCompanionBuilder,
    (CollectionClothingItem,BaseReferences<_$AppDatabase,$CollectionClothingItemsTable,CollectionClothingItem>),
    CollectionClothingItem,
    PrefetchHooks Function()
    >;class $AppDatabaseManager {
final _$AppDatabase _db;
$AppDatabaseManager(this._db);
$$ClothingItemsTableTableManager get clothingItems => $$ClothingItemsTableTableManager(_db, _db.clothingItems);
$$OutfitsTableTableManager get outfits => $$OutfitsTableTableManager(_db, _db.outfits);
$$OutfitClothingItemsTableTableManager get outfitClothingItems => $$OutfitClothingItemsTableTableManager(_db, _db.outfitClothingItems);
$$CollectionsTableTableManager get collections => $$CollectionsTableTableManager(_db, _db.collections);
$$CollectionOutfitsTableTableManager get collectionOutfits => $$CollectionOutfitsTableTableManager(_db, _db.collectionOutfits);
$$CollectionClothingItemsTableTableManager get collectionClothingItems => $$CollectionClothingItemsTableTableManager(_db, _db.collectionClothingItems);
}
