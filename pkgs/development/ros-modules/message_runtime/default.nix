{ stdenv
, mkRosPackage
, fetchFromGitHub
, catkin
, genmsg
, gencpp
, genpy
, cpp_common
, roscpp_serialization
, roscpp_traits
, rostime
}:

let
  pname = "message_runtime";
  version = "0.4.12";

in mkRosPackage {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "${pname}-release";
    rev = "release/lunar/${pname}/${version}-0";
    sha256 = "0mh60p1arv7gj0w0wgg3c4by76dg02nd5hkd4bh5g6pgchigr0qy";
  };

  propagatedBuildInputs =
  [ catkin genmsg gencpp genpy cpp_common roscpp_serialization roscpp_traits rostime ];

  meta = with stdenv.lib; {
    description = "Package modeling the run-time dependencies for language bindings of messages";
    homepage = http://wiki.ros.org/message_runtime;
    license = licenses.bsd3;
    maintainers = [ maintainers.akru ];
  };
}
