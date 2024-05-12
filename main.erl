-module(main).
-export([start/0]).

start() ->
    Symbols = [" "," "," "," "," "," "," "," "," "],
    io:format("Welcome to tic-tac-toe! ~n"),
    {ok, Input} = io:read("Type 'single' to play against a computer, or 'multi' to play against a partner: "),
    case Input of
        single -> 
            draw_board(Symbols),
            single_player_loop(Symbols, "O");
        multi ->
            draw_board(Symbols),
            multi_player_loop(Symbols, "O");
        _ ->
            io:format("Invalid input~n")
    end.

multi_player_loop(OldSymbols, Char) ->
    % toggle between the X and the O character
    case Char of
        "X" ->
            Character = "O";
        _ ->
            Character = "X"
    end,

    % Get the position that the user would like to place a symbol in
    UserDecision = get_input(OldSymbols),

    % Update the board based on the users decision
    case UserDecision of
        stop -> 
            io:format("Thanks for playing!~n");
        _ ->
            NewSymbols = update_symbols_list(UserDecision, Character, OldSymbols),
            draw_board(NewSymbols),

            % End or continue the game depending on if a win condition has been met
            Status = win_condition_met(NewSymbols),
            case Status of
                x ->
                    io:format("X wins!~n");
                o -> 
                    io:format("O wins!~n");
                cat -> 
                    io:format("It's a cat's game.~n");
                _ ->
                    multi_player_loop(NewSymbols, Character)
            end
    end.

single_player_loop(OldSymbols, Char) ->
    % toggle between the X and the O character
    case Char of
        "X" ->
            Character = "O";
        _ ->
            Character = "X"
    end,

    case Character of
        "X" ->
            % It's the users turn:

            % Get the position that the user would like to place a symbol in
            UserDecision = get_input(OldSymbols),
            case UserDecision of
                stop -> 
                    % End the game if the user typed 'stop'
                    io:format("Thanks for playing!~n");
                _ ->
                    % Continue the game based on the input received from the user
                    NewSymbols = update_symbols_list(UserDecision, Character, OldSymbols),
                    draw_board(NewSymbols),

                    % End the game if a win condition has been met or continue the game
                    Status = win_condition_met(NewSymbols),
                    case Status of
                        x ->
                            io:format("X wins!~n");
                        o -> 
                            io:format("O wins!~n");
                        cat -> 
                            io:format("It's a cat's game.~n");
                        _ ->
                            single_player_loop(NewSymbols, Character)
                    end
            end;
        _ ->
            %It's the computers turn:
            NewSymbols = update_symbols_list(computer_decision(OldSymbols), Character, OldSymbols),
            draw_board(NewSymbols),
            % End the game if a win condition has been met or continue the game
            Status = win_condition_met(NewSymbols),
            case Status of
                x ->
                    io:format("X wins!~n");
                o -> 
                    io:format("O wins!~n");
                cat -> 
                    io:format("It's a cat's game.~n");
                _ ->
                    single_player_loop(NewSymbols, Character)
            end
    end.

get_input(Symbols = [A,B,C,D,E,F,G,H,I]) ->
    % Get the user's selection
    {ok, Input} = io:read("Type the number of where you would you like to go next (type 'stop' to quit): "),
    
    % Verify that the user's selection is a legal spot to go.
    case Input of
        0 ->
            verify_input(A, Input, Symbols);
        1 ->
            verify_input(B, Input, Symbols);
        2 -> 
            verify_input(C, Input, Symbols);
        3 ->
            verify_input(D, Input, Symbols);
        4 ->
            verify_input(E, Input, Symbols);
        5 ->
            verify_input(F, Input, Symbols);
        6 ->
            verify_input(G, Input, Symbols);
        7 ->
            verify_input(H, Input, Symbols);
        8 ->
            verify_input(I, Input, Symbols);
        stop -> 
            Input;
        _ ->
            io:format("Invalid position. Please try again~n"),
            get_input(Symbols)
    end.

verify_input(Symbol, Position, Symbols) ->
    % Make sure that te selected spot is empty
    case Symbol of
        " " -> 
            Position;
        _ -> 
            io:format("Invalid position. Please try again~n"),
            get_input(Symbols)
    end.

update_symbols_list(0, Newcharacter, [_First|Rest]) ->
    [Newcharacter|Rest];
update_symbols_list(Index, Newcharacter, [First|Rest]) ->
    [First|update_symbols_list(Index-1, Newcharacter, Rest)].

draw_board([A,B,C,D,E,F,G,H,I]) ->
    io:format("Game Board:     Key:~n"),
    io:format(" ~s | ~s | ~s      0 | 1 | 2 ~n", [A,B,C]),
    io:format("---|---|---    ---|---|---~n"),
    io:format(" ~s | ~s | ~s      3 | 4 | 5 ~n", [D,E,F]),
    io:format("---|---|---    ---|---|---~n"),
    io:format(" ~s | ~s | ~s      6 | 7 | 8 ~n", [G,H,I]).

computer_decision(Symbols) ->
    % Check if there is a spot to go that will win the game
    case computer_decision_helper(Symbols, Symbols, "O", 0, o) of
        fail ->
            % Check if there is a spot to go that will block the user from winning
            case computer_decision_helper(Symbols, Symbols, "X", 0, x) of
                fail ->
                    % Go in a random available spot
                    pick_available_spot(Symbols, 0);
                Position ->
                    Position
            end;
        Position ->
            Position
    end.


computer_decision_helper([], _, _, _, _) ->
    fail;
computer_decision_helper([" "|Rest], Symbols, Character, Position, CheckValue) ->
    TestSymbolList = update_symbols_list(Position, Character, Symbols),
    case win_condition_met(TestSymbolList) of
        CheckValue ->
            Position;
        _ ->
            computer_decision_helper(Rest, Symbols, Character, Position + 1, CheckValue)
    end;
computer_decision_helper([_|Rest], Symbols, Character, Position, CheckValue) ->
    computer_decision_helper(Rest, Symbols, Character, Position + 1, CheckValue).

pick_available_spot([], _) ->
    io:format("Something went wrong"),
    fail; % No spot was available
pick_available_spot([" "|_], Position) ->
    Position;
pick_available_spot([_|Rest], Position) ->
    pick_available_spot(Rest, Position + 1).



% Check if X has won
win_condition_met(["X","X","X",_,_,_,_,_,_]) -> x;
win_condition_met([_,_,_,"X","X","X",_,_,_]) -> x;
win_condition_met([_,_,_,_,_,_,"X","X","X"]) -> x;
win_condition_met(["X",_,_,"X",_,_,"X",_,_]) -> x;
win_condition_met([_,"X",_,_,"X",_,_,"X",_]) -> x;
win_condition_met([_,_,"X",_,_,"X",_,_,"X"]) -> x;
win_condition_met(["X",_,_,_,"X",_,_,_,"X"]) -> x;
win_condition_met([_,_,"X",_,"X",_,"X",_,_]) -> x;

% Check if O has won
win_condition_met(["O","O","O",_,_,_,_,_,_]) -> o;
win_condition_met([_,_,_,"O","O","O",_,_,_]) -> o;
win_condition_met([_,_,_,_,_,_,"O","O","O"]) -> o;
win_condition_met(["O",_,_,"O",_,_,"O",_,_]) -> o;
win_condition_met([_,"O",_,_,"O",_,_,"O",_]) -> o;
win_condition_met([_,_,"O",_,_,"O",_,_,"O"]) -> o;
win_condition_met(["O",_,_,_,"O",_,_,_,"O"]) -> o;
win_condition_met([_,_,"O",_,"O",_,"O",_,_]) -> o;

% Check if there is at least one blank space left
win_condition_met([" ",_,_,_,_,_,_,_,_]) -> no;
win_condition_met([_," ",_,_,_,_,_,_,_]) -> no;
win_condition_met([_,_," ",_,_,_,_,_,_]) -> no;
win_condition_met([_,_,_," ",_,_,_,_,_]) -> no;
win_condition_met([_,_,_,_," ",_,_,_,_]) -> no;
win_condition_met([_,_,_,_,_," ",_,_,_]) -> no;
win_condition_met([_,_,_,_,_,_," ",_,_]) -> no;
win_condition_met([_,_,_,_,_,_,_," ",_]) -> no;
win_condition_met([_,_,_,_,_,_,_,_," "]) -> no;

% If no blank space, it's a cat's game
win_condition_met(_) -> cat.