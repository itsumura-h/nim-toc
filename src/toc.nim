import os, strutils, re

proc getLinksByFile(path:string):seq[string] =
  var mdFileList = newSeq[string]()
  echo path
  try:
    var fileContent = readFile(path).splitLines()
    for row in fileContent:
      if row.matchLen(re"^(?=.*\/)(?=.+\.md).*$") > 0 and not row.contains("README"):
        mdFileList.add(
          getLinksByFile(
            parentDir(path) / row.findAll(re"[\w\d\/\.]+.md")[0]
          )
        )
  except:
    discard
  echo mdFileList
  
  return mdFileList

proc generateToc*(rootFile="README.md"):int =
  let rootFilePath = getCurrentDir() / rootFile
  
  # ファイルを開いてマークダウンへのリンクを取り出す
  var mdFileList = @[rootFilePath]
  mdFileList.add(
    getLinksByFile(rootFilePath)
  )
  echo mdFileList
  return 0
