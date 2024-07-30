function processFiles() {
  var folderId = 'YOUR_FOLDER_ID'; // Google DriveのフォルダIDを指定
  var folder = DriveApp.getFolderById(folderId);
  var files = folder.getFiles();

  while (files.hasNext()) {
    var file = files.next();
    var filename = file.getName();
    var baseName = filename.split('.').slice(0, -1).join('.'); // 拡張子を除いたファイル名
    var extension = filename.split('.').pop(); // 拡張子

    // ファイル名が6文字で、最初の2文字が'O0'であることを確認
    if (baseName.length === 6 && baseName.startsWith('O0')) {
      // 新しいファイル名を作成（先頭の'O0'を削除）
      var newBaseName = 'O' + baseName.slice(2);
      var newFilename = newBaseName + (extension ? '.' + extension : '');

      // ファイル名の変更
      file.setName(newFilename);

      // ファイルの内容を読み込む
      var fileContent = file.getBlob().getDataAsString();
      var lines = fileContent.split('\n');

      // 2行目をチェックし、変更前ファイル名が含まれていれば置き換える
      if (lines.length > 1 && lines[1].includes(baseName)) {
        lines[1] = lines[1].replace(new RegExp(baseName, 'g'), newBaseName);
        var newContent = lines.join('\n');

        // 変更を反映するためのファイルの内容を書き換える
        file.setContent(newContent);
      }
    }
  }
}
