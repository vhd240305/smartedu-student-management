package api;

public class ApiResponse {
	private int status;
	private String message;
	private Object data;
	private long timestamp;

	public ApiResponse(int status, String message, Object data) {
		this.status = status;
		this.message = message;
		this.data = data;
		this.timestamp = System.currentTimeMillis();
	}

	// Getters
	public int getStatus() {
		return status;
	}

	public String getMessage() {
		return message;
	}

	public Object getData() {
		return data;
	}

	public long getTimestamp() {
		return timestamp;
	}
}