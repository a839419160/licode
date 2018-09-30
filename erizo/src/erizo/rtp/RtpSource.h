
/*
 * RtpSource.h
 *
 *  Created on: Aug 2, 2012
 *      Author: pedro
 */
#ifndef ERIZO_SRC_ERIZO_RTP_RTPSOURCE_H_
#define ERIZO_SRC_ERIZO_RTP_RTPSOURCE_H_

#include <asio.hpp>
#include <thread>
#include <mutex>

#include <string>

#include "./MediaDefinitions.h"
#include "./logger.h"

namespace erizo {

class RtpSource: public MediaSource, public FeedbackSink {
  DECLARE_LOGGER();

 public:
  RtpSource(const int mediaPort, const std::string& feedbackDir, const std::string& feedbackPort);
  virtual ~RtpSource();

 private:
  static const int LENGTH = 1500;
  std::unique_ptr<asio::ip::udp::socket> socket_, fbSocket_;
  std::unique_ptr<asio::ip::udp::resolver> resolver_;
  std::unique_ptr<asio::ip::udp::resolver::query> query_;
  asio::ip::udp::resolver::iterator iterator_;
  asio::io_service io_service_;
  std::thread rtpSource_thread_;
  char* buffer_[LENGTH];
  void handleReceive(const asio::error_code& error, size_t bytes_recvd); // NOLINT
  void eventLoop();
  int deliverFeedback_(std::shared_ptr<DataPacket> fb_packet) override;
};


}  // namespace erizo
#endif  // ERIZO_SRC_ERIZO_RTP_RTPSOURCE_H_
