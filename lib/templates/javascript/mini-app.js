class MiniApp {
    constructor (facade) {
        this.modules = {}
        this.facade = facade
    }

    register (name, fn) {
        this.modules[name] = {
            fn: fn,
            instance: null
        }
    }

    start () {
        for (const name in this.modules) {
            var module = this.modules[name]
            /* eslint-disable new-cap */
            module.instance = new module.fn(this.facade)
            /* eslint-enable new-cap */
            module.instance.el = this.facade.query(name)
            if (module.instance.init) {
                module.instance.init()
            }
        }
    }
}

export default MiniApp
