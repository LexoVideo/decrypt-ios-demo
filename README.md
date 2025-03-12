# decrypt-ios-demo

## Get the SDK
```
source 'https://github.com/CocoaPods/Specs.git' 
source 'https://github.com/LexoVideo/lexo-dev-specs.git'
```

DO NOT USE Direct URL to download any more!!

## Add the dependecy
```swift
pod 'DRMLib'
```

## Decrypt the resource
1) create an plugin
```swift
let encryptKey = "your_encrypt_key" // the encrypt key to decrypt your video
var plugin: DRMPlugin = .init(encryptKey: encryptKey)
```
2) enable/disable the encrypt(drm check)
The lib will use decrypt for default, if you want to disable/enable it by url or something else, change the result in the block. 
```swift
plugin.shouldCheckDRM = { url in
    return true
}
``` 
2) process the stream data
send a piece of stream data to the plugin, and check the result.
if success, then you can use the decrypt data.
if return an failure of .requireMoreData, it means the lib need more data to perform decrypt action, please send more data to plugin to process.

```swift
let decryptResult = plugin.process(url: "your resour url", data: subData)
// check the result
switch decryptResult {
case .success(let success):
    // success
    // you can store the decrypt data, or return it to the player stream.
    print("decrypt success")
case .failure(let failure):
    // there's something happened
    switch failure {
    case .requireMoreData:
        // the piece data is too small
        // require more data to process decrypt
        print("requre more data")
        continue
    default:
        // other exception, there must be some error
        print("failure \(failure)")
        fatalError()
    }
}

```
