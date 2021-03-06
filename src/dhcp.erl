-module(dhcp).

-include("dhcp.hrl").

-opaque package() :: #dhcp_package{}.
-opaque option() :: dhcp_option().
-opaque flags() :: dhcp_flags().
-opaque op() :: dhcp_op().

-export_type([package/0, ip/0, short/0, mac/0, dhcp_op/0, htype/0, int32/0, option/0, flags/0, message_type/0, op/0,package_fields/0]).

-ignore_xref([ip_to_tpl/1, tpl_to_ip/1]).
-ifdef(TEST).
-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").
-endif.

-export([ip_to_tpl/1, tpl_to_ip/1]).

-spec ip_to_tpl(ip()) -> ip_tpl().

ip_to_tpl(I) when is_integer(I) ->
    <<A:8, B:8, C:8, D:8>> = <<I:32>>,
    {A, B, C, D}.

-spec tpl_to_ip(ip_tpl()) -> ip().

tpl_to_ip({A, B, C, D}) ->
    <<I:32>> = <<A:8, B:8, C:8, D:8>>,
    I.

-ifdef(TEST).

prop_ip_tpl_conversion() ->
    ?FORALL(Tpl, ip_tpl(),
            begin
                EncDecTpl = ip_to_tpl(tpl_to_ip(Tpl)),
                EncDecTpl =:= Tpl
            end).

propper_test() ->
    ?assertEqual(true, proper:check_spec({dhcp, ip_to_tpl, 1}, [{to_file, user}])),
    ?assertEqual(true, proper:check_spec({dhcp, tpl_to_ip, 1}, [{to_file, user}])),
    ?assertEqual([], proper:module(?MODULE, [{to_file, user}])).

ip2tpl_test() ->
    ?assertEqual({1,2,3,4}, ip_to_tpl(16#01020304)),
    ?assertEqual({0,0,0,0}, ip_to_tpl(16#00000000)),
    ?assertEqual({255,255,255,255}, ip_to_tpl(16#FFFFFFFF)).

tpl2ip_test() ->
    ?assertEqual(16#01020304, tpl_to_ip({1,2,3,4})),
    ?assertEqual(16#00000000, tpl_to_ip({0,0,0,0})),
    ?assertEqual(16#FFFFFFFF, tpl_to_ip({255,255,255,255})).

-endif.

