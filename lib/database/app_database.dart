import 'package:path/path.dart';
import 'package:projects/database/dao/contact_dao.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDataBase() async {
  final String path = join(await getDatabasesPath(), 'bytebank.db');
  return openDatabase(
    path,
    onCreate: (db, version) {
      db.execute(ContactDao.tableSql);
    }, version: 1,
     // onDowngrade: onDatabaseDowngradeDelete   //limpar banco de dados, apenas subir o numero da versão, executar e depois descer novamente,  exemplo de 1 p/ 2 e de 2 p/ 1.
  );
}
