#include <media/MediaProcessor.h>
#include <media/utils/RtpUtils.h>
#include <asio.hpp>

#ifndef TEST_H_
#define TEST_H_
namespace erizo {
class Test: public RawDataReceiver {
public:
	Test();
	virtual ~Test();
	void receiveRawData(unsigned char*data, int len);

	void rec();
	void send(char *buff, int buffSize);
private:

	asio::ip::udp::socket* socket_;
	asio::ip::udp::resolver* resolver_;

	asio::ip::udp::resolver::query* query_;
	asio::io_service* ioservice_;
	InputProcessor* ip;
	erizo::RtpParser pars;

};

}
#endif /* TEST_H_ */
