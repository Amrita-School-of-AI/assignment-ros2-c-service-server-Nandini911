#include "rclcpp/rclcpp.hpp"
#include "example_interfaces/srv/add_two_ints.hpp"

using AddTwoInts = example_interfaces::srv::AddTwoInts;
using std::placeholders::_1;
using std::placeholders::_2;

class ServiceServerNode : public rclcpp::Node
{
public:
  ServiceServerNode() : Node("service_server_node")
  {
    service_ = this->create_service<AddTwoInts>(
      "add_two_ints",
      std::bind(&ServiceServerNode::handle_service, this, _1, _2)
    );

    RCLCPP_INFO(this->get_logger(), "Service Server is ready");
  }

private:
  void handle_service(
    const std::shared_ptr<AddTwoInts::Request> request,
    std::shared_ptr<AddTwoInts::Response> response)
  {
    response->sum = request->a + request->b;

    RCLCPP_INFO(
      this->get_logger(),
      "Received request: a=%ld b=%ld",
      request->a, request->b
    );

    RCLCPP_INFO(
      this->get_logger(),
      "Sending response: sum=%ld",
      response->sum
    );
  }

  rclcpp::Service<AddTwoInts>::SharedPtr service_;
};

int main(int argc, char **argv)
{
  rclcpp::init(argc, argv);
  rclcpp::spin(std::make_shared<ServiceServerNode>());
  rclcpp::shutdown();
  return 0;
}
