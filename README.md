## Flutter で GoogleMaps を使うサンプル

- APIキーを取得したら両OSそれぞれ次のとおりに置き換えてください
  - iOS: AppDelegate.swift内の `MAPS_API_KEY` を取得したキーに置き換える
  - Android: AndroidManifest.xml内の `MAPS_API_KEY` を取得したキーに置き換える
- パーミッション許可周りなどサンプルなので異常系を省いています
  - パーミッションの取得には[geolocator](https://pub.dev/packages/geolocator)を使用しています。実際の開発では[permission_handler](https://pub.dev/packages/permission_handler)を使う機会の方が多いかもしれません。
- 同様にサンプルなのでRiverpodなどを使わず他の知識を極力不要にしています
  - 実際の開発では初回のデータ取得をHooksでいい感じにしたり、Markerの更新などStateNotifierを使うなどしていい感じにしたりできるはずです
  
## このサンプルで試していること

- 地図の表示（拡大/縮小/移動）
- 現在地を表示、現在地に移動する
- 緯度経度を持ったリストを基に地図にピンを立てる
- ピンにinfo windowを表示する
- ピンの画像を変更する
  - Uint8Listに一度変換することで元画像のサイズを正しく反映させています
- ピンをタップした際になにか処理をする
  - サンプルではダイアログを表示しています
- 緯度経度を指定してその座標に地図の中心を移動させる

## 免責事項

- 本ソースコードはサンプルソースコードであるため、作者は本ソースコードに関して一切の動作保証をするものではありません。
- 本ソースコードで発生した結果、および生成物について保証するものではありません。また、本ソースコードの使用により生じた損害ならびに、第三者に直接または間接的に生じた損害について、作者は法律上の根拠を問わずいかなる責任も負わないものとします。

---

## Sample of using GoogleMaps with Flutter

- After you get the API key, replace it with the following for both operating systems
  - iOS: Replace `MAPS_API_KEY` in AppDelegate.swift with the key you got.
  - Android: Replace `MAPS_API_KEY` in AndroidManifest.xml with the key you got.
- Getting permissions and other errors are omitted in this sample.
  - To get permissions, we use [geolocator](https://pub.dev/packages/geolocator). In actual development, you may have more chances to use [permission_handler](https://pub.dev/packages/permission_handler).
- Similarly, since this is a sample, it does not use Riverpod, etc. and requires as little knowledge as possible.
  - In actual development, you should be able to use Hooks to get the data for the first time, or use StateNotifier to update the Marker.
  
## What we are trying in this sample

- Map display (zoom in/out/move around)
- Show current location, move to current location
- Set up a pin on the map based on a list with latitude and longitude
- Display an info window on the pin
- Change the image of the pin
  - Convert the image to Uint8List once to correctly reflect the size of the original image.
- Do something when the pin is tapped
  - In the sample, a dialog is displayed.
- Specify the latitude and longitude, and move the center of the map to those coordinates.

## Disclaimer

- Since this is a sample source code, the author does not guarantee any operation of this source code.
- The author does not guarantee the results or products generated by this source code. In addition, the author assumes no responsibility whatsoever, regardless of the legal basis, for any damage caused by the use of this source code, or for any damage caused directly or indirectly to a third party.
