package om;

class Emitter<T> implements Disposable {

    public var numHandlers(default,null) : Int;

    var map : Map<String,Array<T->Void>>;

    public function new() {
        clear();
    }

    /**
        Clear out any existing subscribers.
    */
    public function clear() : Emitter<T> {
        map = new Map();
        numHandlers = 0;
        return this;
    }

    /**
        Unsubscribe all handlers.
    */
    public function dispose() {
        clear();
    }

    /**
        Register the given handler function to be invoked whenever events by the given name are emitted via emit.
    */
    public function on( eventName : String, handler : T->Void, unshift = false ) : Emitter<T> {
        map.exists( eventName ) ? map.get( eventName ).push( handler ) : map.set( eventName, [handler] );
        numHandlers++;
        return this;
    }

    /**
        Register the given handler function to be invoked before all other handlers existing at the time of subscription whenever events by the given name are emitted via emit.
    */
    public function preempt( eventName : String, handler : T->Void ) : Emitter<T> {
        if( map.exists( eventName ) ) {
            map.get( eventName ).unshift( handler );
        } else {
            map.set( eventName, [handler] );
        }
        numHandlers++;
        return this;
    }

    /**
        Invoke registered handlers.
    */
    public function emit( eventName : String, value : T ) : Emitter<T> {
        if( map.exists( eventName ) )
            for( h in map.get( eventName ) )
                h( value );
        return this;
    }

    function off( eventName : String, handlerToRemove : T->Void ) : Emitter<T> {
        if( map.exists( eventName ) )
        map.get( eventName ).remove( handlerToRemove );
        return this;
    }

}