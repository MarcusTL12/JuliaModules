# consoleutil.jl (v0.1)

function putmenu()

    f = open("consolemenu.txt");
    
    println(read(f, String));

    close(f);

    choice::Int = 0;

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

