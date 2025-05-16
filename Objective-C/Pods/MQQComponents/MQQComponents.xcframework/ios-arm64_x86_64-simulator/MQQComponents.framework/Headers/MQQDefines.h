//
//  MQQDefines.h
//  MQQSecure
//
//  Created by klaudz on 10/16/14.
//  Copyright (c) 2014 Tencent. All rights reserved.
//


// MQQ_EXTERN
#if !defined(MQQ_EXTERN)
#  if defined(__cplusplus)
#    define MQQ_EXTERN extern "C"
#  else
#    define MQQ_EXTERN extern
#  endif
#endif

// MQQ_INLINE
#if !defined(MQQ_INLINE)
#  if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#    define MQQ_INLINE static inline
#  elif defined(__cplusplus)
#    define MQQ_INLINE static inline
#  elif defined(__GNUC__)
#    define MQQ_INLINE static __inline__
#  else
#    define MQQ_INLINE static
#  endif
#endif
