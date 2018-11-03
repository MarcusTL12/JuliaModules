# consoleutil.jl (v0.1)

function putmenu()

    f = open("consolemenu.txt");
    
    println(read(f, String));

    close(f);

    choice::Int = 0;

    while !choice

        choice = cini();

    end

    invokechoice(choice);

end

function invokechoice(choice::Int)

    if choice == 1
        #newenemy()
    elseif choice == 2
        #searchforenemy()
    elseif choice == 3
        #altercurrentenemy()
    elseif choice == 4
        #deletecurrentenemy()
    elseif choice == -1
        return;
    end
    

end

function cini(prompt::String = "")::Int32

    print(prompt);

    while true
        try
            return parse(Int32, readline());
        catch err
            println(err);
        end 
    end
end

function cinf(prompt::String = "")::Float32
    
    print(prompt);
    
    while true
        try
            return parse(Float32, readline());
        catch err
            println(err);
        end
    end
end

function multiread(t::DataType, lines::Int = -1, prompt::String = "")
    ret::Array{t, 1} = [];
    tmp::String = "";

    print(prompt);
    
    if lines == -1
        println("Send \"__stop\" to end reading.");
        stop::Bool = false;

        while !stop
            tmp = readline();

            if tmp == "__stop"
                stop = true;
                continue;
            else
                push!(ret, parse(t, tmp));
            end
        end
    else
        for i = 1:lines
            push!(ret, parse(t, readline()));
        end
    end

    return ret;
    
end

# cin reads from STDIN. It reads the DataType t.
# lines specifies how many lines one wishes to read. One line is standard.
# -1 lines reads until "__stop" is given.
# prompt is shown when cin is called.
function cin(t::DataType, lines::Int = 1, prompt::String = "")
    
    line::String = "";
    ret::Array{t, 1} = [];

    print(prompt);
    
    if lines == -1

        println("Send \"__stop\" to end reading.");
        stop::Bool = false;

        while !stop
            line = readline();

            if line == "__stop"
                stop = true;
                continue;
            else
                try
                    push!(ret, parse(t, line));
                catch err
                    if err isa MethodError && t == String
                        push!(ret, line);
                    else
                        println(err);
                    end
                end
            end
        end

    elseif lines == 1

        if t == String
            return readline();
        else
            while true
                try
                    return parse(t, readline());
                catch err
                    println(err);
                end
            end
        end

    else
        if t == String
            for i = 1:lines
                push!(ret, readline());
            end
        else
            for i = 1:lines
                push!(ret, cin(t));
            end
        end
                
    end # end if lines == -1

    return ret;
end

