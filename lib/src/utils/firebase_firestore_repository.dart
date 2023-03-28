// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_comp/src/utils/utils.dart';

class FirebaseFirestoreService<T> {
  late final String collectionPath;
  late final FirebaseFirestore firestore;

  /// Used to serialize your data to JSON when using 'WithConverter' methods.
  final Map<String, dynamic> Function(T value) _toJson;

  /// Used to deserialize your data to JSON when using 'WithConverter' methods.
  final T Function(Map<String, dynamic> json, String? id) _fromJson;

  /// Esse é o Service principal onde o FirebaseFirestoreRepository extende sua funções.
  FirebaseFirestoreService({
    required this.firestore,
    required this.collectionPath,
    required Map<String, dynamic> Function(T value) toJson,
    required T Function(Map<String, dynamic> json, String? id) fromJson,
  })  : _toJson = toJson,
        _fromJson = fromJson;

  CollectionReference<T> get collection => firestore.collection(collectionPath).withConverter<T>(
        fromFirestore: (snapshots, _) => _fromJson(snapshots.data()!, snapshots.id.toString()),
        toFirestore: (model, _) => _toJson(model),
      );

  Future<T> adicionar({
    required T model,
    CollectionReference<T>? collectionCustom,
    int timeoutSeconds = 10,
  }) {
    CollectionReference<T> collectionRef = collectionCustom ?? collection;
    return collectionRef.add(model).timeout(Duration(seconds: timeoutSeconds)).then((value) async {
      await collectionRef.doc(value.id).update({"id": value.id}).timeout(Duration(seconds: timeoutSeconds));
      return _fromJson(_toJson(model), value.id);
    });
  }

  Future<void> atualizar({
    required T model,
    required String docId,
    CollectionReference<T>? collectionCustom,
    int timeoutSeconds = 10,
  }) {
    CollectionReference<T> collectionRef = collectionCustom ?? collection;
    if (docId.isEmpty) {
      throw "Inválido docId";
    }
    return collectionRef.doc(docId).update(_toJson(model)).timeout(Duration(seconds: timeoutSeconds));
  }

  Future<T?> buscarPeloId({
    required String docId,
    CollectionReference<T>? collectionCustom,
    int timeoutSeconds = 10,
  }) async {
    CollectionReference<T> collectionRef = collectionCustom ?? collection;
    if (docId.isEmpty) {
      throw "Inválido docId";
    }
    return (await collectionRef.doc(docId).get().timeout(Duration(seconds: timeoutSeconds))).data();
  }

  Future<void> apagar(
    String docId, {
    CollectionReference<T>? collectionCustom,
    int timeoutSeconds = 10,
  }) {
    CollectionReference<T> collectionRef = collectionCustom ?? collection;
    if (docId.isEmpty) {
      throw "Inválido docId";
    }
    return collectionRef.doc(docId).delete().timeout(Duration(seconds: timeoutSeconds));
  }

  Future<List<T>> buscarTodos({
    QueryConstraint? where,
    List<QueryConstraint>? whereList,
    String? orderBy,
    bool descending = false,
    int? limit,
    CollectionReference<T>? collectionCustom,
    int timeoutSeconds = 10,
  }) async {
    Query<T> query = collectionCustom ?? collection;

    if (where != null) {
      query = where.operator(query);
    }

    if (whereList != null) {
      for (final where in whereList) {
        query = where.operator(query);
      }
    }

    if (orderBy != null) {
      query = query.orderBy(orderBy, descending: descending);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    final QuerySnapshot<T> querySnapshot = await getTimeout(query, seconds: timeoutSeconds);

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }
}

class FirebaseFirestoreRepository<T> extends FirebaseFirestoreService<T> {
  // final FirebaseFirestoreService<T> service;

  FirebaseFirestoreRepository({
    required FirebaseFirestore firestore,
    required String collectionPath,
    required Map<String, dynamic> Function(T value) toJson,
    required T Function(Map<String, dynamic> json, String? id) fromJson,
  }) : super(
          toJson: toJson,
          fromJson: fromJson,
          firestore: firestore,
          collectionPath: collectionPath,
        );

  /// Função para adicionar um novo Modelo ao Firebase
  /// Exemplo:
  /// ```dart
  /// final teste = Teste(
  ///   id: "1",
  ///   nome: "Novo Modelo",
  /// );
  /// final repo = TesteRepository();
  /// await repo.adicionar(
  ///   model: teste,
  /// );
  /// ```
  @override
  Future<T> adicionar({
    required T model,
    CollectionReference<T>? collectionCustom,
    int timeoutSeconds = 10,
  }) {
    return super.adicionar(
      model: model,
      collectionCustom: collectionCustom,
      timeoutSeconds: timeoutSeconds,
    );
  }

  /// Função que busca um Modelo pelo id e retorna se encontrar, caso não encontre retorna null.
  /// Exemplo:
  /// ```dart
  /// final repo = TesteRepository();
  /// final buscaId = await repo.buscarPeloId(
  ///   docId: "1",
  /// );
  /// ```
  @override
  Future<T?> buscarPeloId({
    required String docId,
    CollectionReference<T>? collectionCustom,
    int timeoutSeconds = 10,
  }) {
    return super.buscarPeloId(
      docId: docId,
      collectionCustom: collectionCustom,
      timeoutSeconds: timeoutSeconds,
    );
  }

  /// Função que atualiza um modelo.
  /// Exemplo:
  /// ```dart
  /// final teste = Teste(
  ///   id: "1",
  ///   nome: "Atualizando",
  ///   categoria: "TESTE",
  /// );
  /// final repo = TesteRepository();
  /// await repo.atualizar(
  ///   model: teste,
  ///   docId: "1",
  /// );
  /// ```
  @override
  Future<void> atualizar({
    required T model,
    required String docId,
    CollectionReference<T>? collectionCustom,
    int timeoutSeconds = 10,
  }) {
    return super.atualizar(
      model: model,
      docId: docId,
      collectionCustom: collectionCustom,
      timeoutSeconds: timeoutSeconds,
    );
  }

  /// Função que apaga um modelo.
  /// Exemplo:
  /// ```dart
  /// final repo = TesteRepository();
  /// await repo.apagar(
  ///   docId: "1",
  /// );
  /// ```
  @override
  Future<void> apagar(
    String docId, {
    CollectionReference<T>? collectionCustom,
    int timeoutSeconds = 10,
  }) {
    return super.apagar(
      docId,
      collectionCustom: collectionCustom,
      timeoutSeconds: timeoutSeconds,
    );
  }

  /// Função que tem filtros[QueryConstraint] prontos para usar na busca, ela retorna uma Lista<Modelo> do modelo que você fizer
  /// Exemplo:
  /// ```dart
  /// final repo = TesteRepository();
  /// List<Teste> todos = await repo.buscarTodos(
  ///   descending: false,
  ///   limit: 10,
  ///   orderBy: "nome",
  ///   where: QueryConstraint(field: "categoria", op: QueryOperation.isEqualTo, value: "INITIAL"),
  ///   // Ou
  ///   whereList: [
  ///     QueryConstraint(field: "categoria", op: QueryOperation.isEqualTo, value: "INITIAL"),
  ///     QueryConstraint(field: "nome", op: QueryOperation.isGreaterThanOrEqualTo, value: "Teste"),
  ///   ],
  /// );
  /// ```
  @override
  Future<List<T>> buscarTodos({
    QueryConstraint? where,
    List<QueryConstraint>? whereList,
    String? orderBy,
    bool descending = false,
    int? limit,
    CollectionReference<T>? collectionCustom,
    int timeoutSeconds = 10,
  }) {
    return super.buscarTodos(
      where: where,
      whereList: whereList,
      orderBy: orderBy,
      descending: descending,
      limit: limit,
      collectionCustom: collectionCustom,
      timeoutSeconds: timeoutSeconds,
    );
  }
}

enum QueryOperation { isEqualTo, isLessThan, isLessThanOrEqualTo, isGreaterThan, isGreaterThanOrEqualTo, arrayContains, whereIn, whereNotIn, arrayContainsAny, isNull, isNotEqualTo }

class QueryConstraint {
  final String field;
  final QueryOperation op;
  final dynamic value;

  QueryConstraint({required this.field, required this.op, required this.value});

  Query<T> operator<T>(Query<T> query) {
    switch (op) {
      case QueryOperation.isEqualTo:
        return query.where(field, isEqualTo: value);
      case QueryOperation.isLessThan:
        return query.where(field, isLessThan: value);
      case QueryOperation.isLessThanOrEqualTo:
        return query.where(field, isLessThanOrEqualTo: value);
      case QueryOperation.isGreaterThan:
        return query.where(field, isGreaterThan: value);
      case QueryOperation.isGreaterThanOrEqualTo:
        return query.where(field, isGreaterThanOrEqualTo: value);
      case QueryOperation.arrayContains:
        return query.where(field, arrayContains: value);
      case QueryOperation.whereIn:
        return query.where(field, whereIn: value);
      case QueryOperation.whereNotIn:
        return query.where(field, whereNotIn: value);
      case QueryOperation.arrayContainsAny:
        return query.where(field, arrayContainsAny: value);
      case QueryOperation.isNull:
        return query.where(field, isNull: value);
      case QueryOperation.isNotEqualTo:
        return query.where(field, isNotEqualTo: value);
    }
  }
}

/*// FORMA DE UTILIZAR O REPOSITORIO GENERICO
class Teste {
  String id = "";
  String nome = "";
  String categoria = "INITIAL";
  Teste({
    required this.id,
    required this.nome,
    this.categoria = "INITIAL",
  });

  Teste.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data()!;
    id = getMap<String>(key: "id", map: map, retur: doc.id);
    nome = getMap<String>(key: "nome", map: map, retur: "");
    categoria = getMap<String>(key: "categoria", map: map, retur: "INITIAL");
  }

  Teste.fromJson(Map<String, dynamic> map, String? id) {
    this.id = id ?? (getMap<String>(key: "id", map: map, retur: ""));
    nome = getMap<String>(key: "nome", map: map, retur: "");
    categoria = getMap<String>(key: "categoria", map: map, retur: "INITIAL");
  }

  static Map<String, dynamic> toJson(Teste model) => {
        "id": model.id,
        "nome": model.nome,
        "categoria": model.categoria,
      };

  @override
  String toString() => 'Teste(id: $id, nome: $nome, categoria: $categoria)\n';
}

class TesteRepository extends FirebaseFirestoreRepository<Teste> {
  /// Esse é um repositorio teste, mostrando com se usa a lib FirebaseFirestoreRepository<Teste>()\n
  ///
  /// Example:
  /// ```dart
  /// class TesteRepository extends FirebaseFirestoreRepository<Teste> {
  ///   TesteRepository()
  ///    : super(
  ///        collectionPath: 'BAIRROS',
  ///        firestore: FirebaseFirestore.instance,
  ///        fromJson: Teste.fromJson,
  ///        toJson: Teste.toJson,
  ///      );
  ///   @override
  ///   CollectionReference<Teste> get collection => super.collection;
  /// 
  ///   Future<List<Teste>> todosByCategoria() async {
  ///     final lista = await collection.where("categoria", isEqualTo: "INITIAL").get().then((value) => value.docs.map((e) => e.data()).toList());
  ///     return lista;
  ///   }
  /// }
  /// 
  /// void main() {
  ///   final repo = TesteRepository();
  ///   final todos = await repo.buscarTodos();
  ///   log(todos.toString());
  ///   
  ///   final todosCat = await repo.todosByCategoria();
  ///   log(todosCat.toString());
  /// }
  /// ```
  TesteRepository()
      : super(
          collectionPath: 'BAIRROS',
          firestore: FirebaseFirestore.instance,
          fromJson: Teste.fromJson,
          toJson: Teste.toJson,
        );

  /// Com essa referencia pode criar novas funcões personalizas para seu Modelo.
  @override
  CollectionReference<Teste> get collection => super.collection;

  /// Exemplo de função personalizada
  /// Vamos criar uma que retorna todos com a categoria INITIAL.

  Future<List<Teste>> todosByCategoria() async {
    final lista = await collection.where("categoria", isEqualTo: "INITIAL").get().then((value) => value.docs.map((e) => e.data()).toList());
    return lista;
  }
}

void teste() async {
  
  final repo = TesteRepository();
  final todos = await repo.buscarTodos(
    descending: false,
    limit: 10,
    orderBy: "nome",
    where: QueryConstraint(field: "categoria", op: QueryOperation.isEqualTo, value: "INITIAL"),
    // Ou
    whereList: [
      QueryConstraint(field: "categoria", op: QueryOperation.isEqualTo, value: "INITIAL"),
      QueryConstraint(field: "nome", op: QueryOperation.isGreaterThanOrEqualTo, value: "Teste"),
    ],
  );
  log(todos.toString());
}
*/