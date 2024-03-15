# AutoRequired
```
@AutoRequired init() {

}
```
Expands to:
```
init() {

}

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
```
