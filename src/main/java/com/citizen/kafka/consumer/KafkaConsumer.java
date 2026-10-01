package com.citizen.kafka.consumer;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class KafkaConsumer {

    @KafkaListener(topics = { "topic-2" }, groupId = "group-1")
    public void listen1(ConsumerRecord<String,String> consumerRecord) {
        log.info("Consumer 1 Listened");
    }

    @KafkaListener(topics = { "topic-2" }, groupId = "group-1")
    public void listen2(ConsumerRecord<String,String> consumerRecord) {
        log.info("Consumer 2 Listened");
    }

    @KafkaListener(topics = { "topic-2" }, groupId = "group-1")
    public void listen3(ConsumerRecord<String,String> consumerRecord) {
        log.info("Consumer 3 Listened");
    }

    @KafkaListener(topics = { "topic-2" }, groupId = "group-1")
    public void listen4(ConsumerRecord<String,String> consumerRecord) {
        log.info("Consumer 4 Listened");
    }

    @KafkaListener(topics = { "topic-2" }, groupId = "group-1")
    public void listen5(ConsumerRecord<String,String> consumerRecord) {
        log.info("Consumer 5 Listened");
    }

    @KafkaListener(topics = { "topic-2" }, groupId = "group-1")
    public void listen6(ConsumerRecord<String,String> consumerRecord) {
        log.info("Consumer 6 Listened");
    }

    @KafkaListener(topics = { "topic-2" }, groupId = "group-1")
    public void listen7(ConsumerRecord<String,String> consumerRecord) {
        log.info("Consumer 7 Listened");
    }

}
