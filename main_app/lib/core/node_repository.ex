defmodule Nodes do
    @cookie :testing
    @list_modules [
        %{:name => :pool, :address => "pool@127.0.0.1", :function => Core.WorkerPool},
        %{:name => :proxy, :address => "proxy@127.0.0.1", :function => Core.Proxy},
        %{:name => :calculator, :address => "calculator@127.0.0.1", :function => Core.Calculator},
        %{:name => :master, :address => "master@127.0.0.1", :function => Core.Master}
    ]

    @list_workers [
        %{:name => :worker, :address => "worker@127.0.0.1"},
        %{:name => :worker1, :address => "worker1@127.0.0.1"},
       # %{:name => :worker2, :address => "worker2@127.0.0.1", :pid => :nil},
       # %{:name => :worker3, :address => "worker3@127.0.0.1", :pid => :nil}
    ]

    def get_module_list() do @list_modules end
    def get_worker_list() do @list_workers end
    def get_cookie() do @cookie end
    def get_pid(module) do search_pid(@list_modules ++ @list_workers, module) end

    defp search_pid(list, module) do
        [head | tail] = list
        if head.name != module do
            search_pid(tail, module)
        else 
            {head[:name], String.to_atom(head[:address])}
        end        
    end

    defp search_map(list, module) do
        [head | _] = list
        head = if head.name != module do
            search_map(list, module)
        else 
            head
        end
        head
    end

end