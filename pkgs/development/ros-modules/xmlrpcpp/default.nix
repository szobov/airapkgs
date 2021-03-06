{ stdenv
, mkRosPackage
, fetchFromGitHub
, catkin
, cpp_common
, rostime
}:

let
  pname = "xmlrpcpp";
  version = "1.13.6";

in mkRosPackage {
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "ros-gbp";
    repo = "ros_comm-release";
    rev = "release/lunar/${pname}/${version}-0";
    sha256 = "1q773y8wkp88agkzz2q06flv2glhxmq18k76jlwf5knm4vhnicrm";
  };

  propagatedBuildInputs = [ catkin cpp_common rostime ];

  meta = with stdenv.lib; {
    description = "C++ implementation of the XML-RPC protocol";
    homepage = http://wiki.ros.org/xmlrpcpp;
    license = licenses.bsd3;
    maintainers = [ maintainers.akru ];
  };
}
